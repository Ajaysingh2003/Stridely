// UserController.ts
import type { Context } from "elysia";
import { redis } from "../lib/redis";
import crypto from "crypto";
// import { sentSms } from "../lib/twilio";
import { inngest } from "../lib/inngest";
import { db } from "../../prisma/seed";
import bcrypt from "bcryptjs";
import { sucrose } from "elysia/sucrose";

type SavedOtp = {
  otp: string;
  name: string;
  phone: string;
  email:string
};

type ProfileContext={
  store:{
    user:{
    id:string,
    role:string,
    phone:string
  }
  }
}

type getAllContext = {
  query: {
    page: string;
    limit: string;
  };
};


type ReqOtpContext = Context<{
  body: {
    phone: string;
    email:string;
    name: string;
  };
}>;

type CreateUserContext =Context<{
  body: {
    name: string;
    phone: string;
    password: string;
    role?: "ADMIN" | "STUDENT";
    email?: string;
  };
}> & {
  jwt: {
    readonly sign: (payload: any) => Promise<string>;
    readonly verify: (token: string) => Promise<any | false>;
  };
};
type adminLoginContext =Context<{
  body: {
    phone: string;
    password: string;
  };
}> & {
  jwt: {
    readonly sign: (payload: any) => Promise<string>;
    readonly verify: (token: string) => Promise<any | false>;
  };
};

type VerifyOtpContext = Context<{
  body: {
    otp: string;
    email: string;
  };
}> & {
  jwt: {
    readonly sign: (payload: any) => Promise<string>;
    readonly verify: (token: string) => Promise<any | false>;
  };
};
export class UserController {

  static async reqOtp({ body, set }: ReqOtpContext) {
    const email = body.email;
    const loginAttemptKey = `login_attempts:${email}`;
    const lockKey = `lock:${email}`;

    // 1. Check if the user is already locked
    const isLocked = await redis.get(lockKey);
    if (isLocked) {
      set.status = 403;
      return { success: false, message: isLocked };
    }

    // 2. Increment attempts
    const currentAttempts = await redis.incr(loginAttemptKey);

    // 3. Set expiry on the first attempt (1 hour window)
    if (currentAttempts === 1) {
      await redis.expire(loginAttemptKey, 3600);
    }

    // 4. Handle Lockout
    const MAX_ATTEMPTS = 5;
    const LOCK_DURATION_SECONDS = 3600; // 1 hour

    if (currentAttempts >= MAX_ATTEMPTS) {
      const lockMsg = `Too many attempts. Account locked for 60 minutes.`;
      await redis.set(lockKey, lockMsg, "EX", LOCK_DURATION_SECONDS);

      set.status = 429;
      return { success: false, message: lockMsg };
    }

    const existingOtp = await redis.get(`otp:${email}`);

    if (!existingOtp) {
      const otp = Math.floor(100000 + Math.random() * 900000).toString();

      await inngest.send({
        name: "otp/send",
        data: {
          email: body.email,
          otp,
        },
      });

      let data = {
        name: body.name,
        otp: otp,
        email:body.email,
        phone: body.phone,
      };

      await redis.set(`otp:${email}`, JSON.stringify(data), "EX", 600);
    }

    return {
      success: true,
      message: "An OTP has been sent to Your email.",
      data: {
        name: body.name,
        phone: body.phone,
        email:body.email
      },
    };
  }

  static async createUser({ body, jwt, set }: CreateUserContext) {
    const { name, phone, password, role = "STUDENT", email = "" } = body;

    if (!name || !phone || !password) {
      set.status = 400;
      return { success: false, message: "Missing required fields!" };
    }

    try {
      // Hash password
      const salt = await bcrypt.genSalt(10);
      const hashedPassword = await bcrypt.hash(password, salt);

      // Upsert user
      const user = await db.user.upsert({
        where: { phone },
        create: {
          name,
          phone,
          password: hashedPassword,
          role,
          email,
          lastLoginAt: new Date(),
        },
        update: {
          name,
          password: hashedPassword,
          role,
          email,
          lastLoginAt: new Date(),
        },
      });

      // Sign JWT
      const token = await jwt.sign({
        id: user.id.toString(),
        phone: user.phone,
        role: user.role,
      });

      // Set cookie
      set.cookie = {
        access_token: {
          value: token,
          httpOnly: true,
          secure: false,
          sameSite: "lax",
          maxAge: 60 * 60 * 24 * 7,
          path: "/",
        },
      };

      return {
        success: true,
        message: "User created successfully",
        token,
        user: { id: user.id, phone: user.phone, name: user.name, role: user.role },
      };
    } catch (error) {
      console.error("Error creating user:", error);
      set.status = 500;
      return { success: false, message: "Failed to create user" };
    }
  }
  
  static async adminLogin({ body, jwt, set }: adminLoginContext) {
    const { phone, password } = body;

    if (!phone || !password) {
      set.status = 400;
      return { success: false, message: "Missing required fields!" };
    }

    try {
      // 1️⃣ Find user
      const user = await db.user.findUnique({
        where: { phone },
      });

      // 2️⃣ User not found
      if (!user) {
        set.status = 404;
        return { success: false, message: "User not found" };
      }

      // 3️⃣ Check role (important for admin login)
      if (user.role !== "ADMIN") {
        set.status = 403;
        return { success: false, message: "Not authorized as admin" };
      }

      // 4️⃣ Compare password (IMPORTANT)
      const isMatch = await bcrypt.compare(password, user.password??"");

      if (!isMatch) {
        set.status = 401;
        return { success: false, message: "Invalid credentials" };
      }

      // 5️⃣ Update last login
      await db.user.update({
        where: { id: user.id },
        data: { lastLoginAt: new Date() },
      });

      // 6️⃣ Generate JWT
      const token = await jwt.sign({
        id: user.id.toString(),
        phone: user.phone,
        role: user.role,
      });

      // 7️⃣ Set cookie
      set.cookie = {
        access_token: {
          value: token,
          httpOnly: true,
          secure: false,
          sameSite: "lax",
          maxAge: 60 * 60 * 24 * 7,
          path: "/",
        },
      };

      return {
        success: true,
        message: "Login successful",
        token,
        user: {
          id: user.id,
          phone: user.phone,
          name: user.name,
          role: user.role,
        },
      };
    } catch (error) {
      console.error("Login error:", error);
      set.status = 500;
      return { success: false, message: "Failed to login" };
    }
  }

  

  static async verifyOtp({ body, set, jwt, cookie }: VerifyOtpContext) {
    const key = `otp:${body.email}`;
    const rawData = await redis.get(key);
    // console.log(key, "456");
    // console.log(rawData, "456");
    // 1️⃣ OTP expired / missing
    if (!rawData) {
      set.status = 410; // Gone
      return { success: false, message: "OTP has expired!" };
    }

    const savedData: SavedOtp = JSON.parse(rawData);

    // 2️⃣ OTP mismatch
    if (savedData.otp !== body.otp) {
      set.status = 400; // Bad Request
      return { success: false, message: "Invalid OTP!" };
    }

    // 3️⃣ Remove OTP from Redis

    // 4️⃣ Upsert user safely
    const user = await db.user.upsert({
      where: { phone: savedData.phone }, 
      create: {
        role:savedData.phone ==="+916269143647" ? "ADMIN" : "STUDENT",
        phone: savedData.phone,
        name: savedData.name,
        
        lastLoginAt: new Date(),
        email: savedData.email,
      },
      update: {
        name: savedData.name,

        lastLoginAt: new Date(),
      },
    });
    const token = await jwt.sign({
      id: user.id.toString(),
      phone: user.phone,
      role:user.role
    });
    console.log(token, "testing testing");
    await redis.del(key);

    set.cookie = {
      access_token: {
        value: token,
        httpOnly: true,
        secure: false,
        sameSite: "lax",
        maxAge: 60 * 60 * 24 * 7,
        path: "/",
      },
    };
    return {
      success: true,
      message: "OTP verified successfully",
      token: token,
    };
  }


  static async profile({ store }:ProfileContext) {

    const user=await db.user.findUnique({
      where:{
        id:store.user.id
      },
      include:{
        userSubscription:{
          orderBy:{
            createdAt:"asc"
          },
          include:{

            class:true
          }
        },
        enrollments:{
          include:{
            workshop:{
              include:{
                location:true
              }
            }
          }
        },
        tutorialAccess:{
          include:{
            tutorial:true
          }
        }
      }
    })

    return{data:user,success:true}
    
  }

  static async getUser({ params,set, }: Context) {
          const { id } = params
    
    // validate id if using Mongo
    if (!id) {
      set.status = 400
      return { message: "Invalid ID" }
    }

    const user = await db.user.findUnique({
      where: { id },
      include:{
        enrollments:{
          include:{
            user:true,
            workshop:true,
            

          }
        },
        tutorialAccess:true,
          userSubscription:{
            include:{
              class:true
            }
          },
          orders:true
      }
    })

    return user
      
      
    }

  static async getAllUsers({ query }: getAllContext) {
      const {
        page = "1",
        limit = "10"
      } = query;
      
      const pageSize = Math.min(Number(limit), 50);
      const where: any = {};
      const filters: any[] = [];
      
      if (filters.length > 0) {
        where.AND = filters;
      }
      
      const pageNumber = Number(page);
  
      const [users, totalCount] = await db.$transaction([
        
        db.user.findMany({
          take: pageSize,
          skip: (pageNumber - 1) * pageSize,
          where,
          orderBy: { createdAt: "asc" },
        }),
  
        db.user.count({ where }),
      ]);
  
      //total pages
      const totalPages = Math.ceil(totalCount / pageSize);
      
      return {
        users,
        pagination: {
          totalCount,
          totalPages,
          currentPage: pageNumber,
        },
      };
    }

    
  static async deleteUser({ params,set, }: Context) {
          const { id } = params
    
    // validate id if using Mongo
    if (!id) {
      set.status = 400
      return { message: "Invalid ID" }
    }

    const user = await db.user.delete({
      where: { id },
    })

    return {
      success:true,
      message:"User Deleted."

    }
      
      
    }


  static async updateUser({ params, body, set }: Context) {
  const { id } = params;

  let bodys=body as any
  if (!id) {
    set.status = 400;
    return { message: "Invalid ID" };
  }

  try {
    const salt = await bcrypt.genSalt(10);
      const hashedPassword = await bcrypt.hash(bodys.password, salt);
        const user = await db.user.update({
        where: { id },
        data: {
          name: bodys.name,
          email: bodys.email,
          phone: bodys.phone,
          avatar: bodys.avatar,
          role: bodys.role,
          password: hashedPassword, 
          lastLoginAt: bodys.lastLoginAt
            ? new Date(bodys.lastLoginAt)
            : undefined,
        },
      });

    return {
      success: true,
      message: "User updated successfully",
      data: user,
    };
  } catch (error: any) {
    set.status = 500;

    // Prisma unique constraint error (like phone/email)
    if (error.code === "P2002") {
      return {
        message: "Email or phone already exists",
      };
    }

    return {
      message: "Something went wrong",
    };
  }
}
    

  private static generateOtp() {
    const otp = crypto.randomInt(1000, 9999);
    return otp;
  }
}