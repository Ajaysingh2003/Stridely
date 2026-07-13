import json
import os
from datetime import datetime
import firebase_admin
from firebase_admin import credentials, firestore
from datetime import datetime, timezone
import uuid
# ─── 1. INITIALIZE FIREBASE SDK ──────────────────────────────────────────────
def initialize_firebase(credentials_path="serviceAccountKey.json"):
    """Initializes the Firebase Admin connection using a service account key."""
    if not os.path.exists(credentials_path):
        raise FileNotFoundError(
            f"Could not find '{credentials_path}'. Please download your service "
            "account key from the Firebase Console and place it in this directory."
        )
    
    cred = credentials.Certificate(credentials_path)
    firebase_admin.initialize_app(cred)
    print("🔥 Firebase Admin SDK initialized successfully.")
    return firestore.client()

# ─── 2. UTILITY: CLEAN AND VALIDATE DATA ─────────────────────────────────────


def clean_data(data_dict):
    """
    Cleans dictionary keys by removing trailing spaces (preventing 'Null' type cast errors in Flutter)
    and converts ISO string timestamps into native Python datetime objects for Firestore.
    """
    cleaned = {}
    for key, value in data_dict.items():
        clean_key = key.strip() # Fixes accidental bugs like "description " -> "description"
        
        # Parse strings that look like ISO timestamps into actual Firestore Timestamps
        if isinstance(value, str) and (value.endswith('Z') or '+' in value):
            try:
                # Truncate fractional seconds for standard ISO format parsing if needed
                iso_str = value.replace('Z', '+00:00')
                cleaned[clean_key] = datetime.fromisoformat(iso_str)
                continue
            except ValueError:
                pass
                
        cleaned[clean_key] = value
    return cleaned


def upload_books(db, mock_data_list, book_metadata):
    """
    Atomically uploads the main book metadata object to the 'books' collection 
    and iterates through the chapter contents array list to seed the 
    'book_content' collection using high-performance batched writes.
    """
    # 1. First, seed the core book object to the 'books' collection
    print(f"\n🚀 Staging core book metadata for: '{book_metadata.get('title')}'...")
    
    batch = db.batch()
    operation_count = 0
    
    book_id = book_metadata.get('uid')
    if not book_id:
        print("❌ Critical Abort: The core book metadata must contain a valid 'uid'.")
        return
        
    book_ref = db.collection('books').document(book_id)
    batch.set(book_ref, clean_data(book_metadata))
    operation_count += 1

    # 2. Iterate through the array list of chapter contents structures
    print(f"🚀 Staging {len(mock_data_list)} chapter cards to 'book_content'...")
    
    for item in mock_data_list:
        cleaned_item = clean_data(item)
        
        # Enforce the relational connection linking the content down to the book parent
        cleaned_item['bookId'] = book_id
        
        doc_id = cleaned_item.get('uid')
        if not doc_id:
            print("⚠️ Skipping record block: Chapter data item must contain a non-empty 'uid'.")
            continue
            
        content_ref = db.collection('book_content').document(doc_id)
        batch.set(content_ref, cleaned_item)
        operation_count += 1
        
        # Firestore absolute hard threshold cap execution limit is 500 operations per block
        if operation_count >= 500:
            batch.commit()
            print(f"📦 Committed batch checkpoint: {operation_count} document mutations processed...")
            batch = db.batch()
            operation_count = 0

    # 3. Safely sweep and commit any remaining data payloads trailing in the queue execution pipeline
    if operation_count > 0:
        batch.commit()
        print(f"📦 Committed final batch trailing payload queue...")
        
    print(f"✅ Transaction block complete! Successfully seeded book metadata and associated chapter content strings into Firestore!")

def delete_by_book_id(db, collection_name: str, book_id: str):
    """
    Delete all documents from a Firestore collection where bookId == book_id.
    """
    docs = (
        db.collection(collection_name)
        .where("bookId", "==", book_id)
        .stream()
    )

    deleted_count = 0
    for doc in docs:
        doc.reference.delete()
        deleted_count += 1

    print(f"✅ Deleted {deleted_count} document(s)")

if __name__ == "__main__":
    try:
        # Establish client instance 
        firestore_db = initialize_firebase("serviceAccountKey.json")
        current_timestamp_iso = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
        book_id=str(uuid.uuid4())

        # Target collection destination path
        # target_collection_name = "book_content"

        book_data = {
    "uid": book_id,
    "title": "How to Make Sh*t Happen",
    "author": {
        "name": "Sean Stephenson",
        "bio": "Sean Stephenson was a renowned motivational speaker, therapist, and self-help author. Born with osteogenesis imperfecta, he overcame immense physical challenges to become a leading expert in personal development, helping millions of people worldwide break through their mental barriers and live with purpose."
    },
    "category": [
        "lNFEAQfx4yhRnnZwQso0"
    ],
    "collections": [
        "13191747-6e2f-419f-ad5f-922d48871188",
        "rTrz6hraKyydjdp7aOwo",
        "37fc63dd-3480-4878-b09d-bebabc47641e"
    ],
    "bookCover": "https://pub-d0026e62fb874713bb7e643ae55b5e34.r2.dev/make_shit_happen.jpg",
    "audioUrl": "https://pub-d0026e62fb874713bb7e643ae55b5e34.r2.dev/audio/how_to_make_shit_happen.mp3",
    "duration": 9,
    "language": "English",
    "rating": 4.9,
    "isFree": True,
    "isFeatured": True,
    "description": "A high-octane guide to overcoming fear, crushing excuses, and taking massive action to achieve your biggest goals.",
    "isDraft": False,
    "tags": [
        {"iconCode": 60232, "tag": "Productivity"},
        {"iconCode": 61380, "tag": "Motivation"},
        {"iconCode": 62414, "tag": "Action"},
        {"iconCode": 61448, "tag": "Self Growth"}
    ],
    
    "createdAt": current_timestamp_iso,
    "updatedAt": current_timestamp_iso,

    "forWhom": "This book is for the 'professional procrastinator'—the person who has big ideas but struggles with the execution. It’s for anyone feeling stuck, scared, or overwhelmed by the gap between where they are and where they want to be.",

    "aboutBook": "How to Make Sh*t Happen is a no-nonsense manifesto on execution. Sean Stephenson pulls no punches in dismantling the internal lies we tell ourselves to justify staying small. Through brutal honesty and actionable strategies, he provides a framework for turning 'someday' into 'right now,' teaching readers how to prioritize their life's purpose and dominate their own excuses.",

    "whatsInside": [
        "Identifying the 'internal stories' that hold you back from making moves.",
        "The necessity of total personal accountability—stopping the blame game.",
        "How to use fear as a compass rather than a stop sign."
    ],

    "takeAways": [
        "Excuses are simply lies you tell yourself to feel better about not doing the work.",
        "Fear doesn't go away just because you're successful; you have to learn to act in spite of it.",
        "Most people overestimate what they can do in a day but underestimate what they can do in a year if they just stay consistent.",
        "You don't need 'permission' to change your life; you just need to make the decision to do it.",
        "True power is found in taking ownership of your results, whether they are good or bad."
    ],

    "quotes": [
        "The only person responsible for your life is you.",
        "Stop waiting for the 'perfect time.' The perfect time is a myth created by cowards.",
        "Your problems are not the problem; your reaction to your problems is the problem.",
        "You are either creating your future or clinging to your past.",
        "Action is the only bridge between a dream and reality."
    ]
}
        
        book_content = [
    {
        "bookId": book_id,
        "uid": str(uuid.uuid4()),
        "position": 1,
        "startTimeMs": 0,
        "title": "Chapter 1: The Myth of 'Someday'",
        "content": """### Chapter 1: The Myth of 'Someday'

Stephenson argues that 'someday' is the most dangerous word in the English language. It is a psychological waiting room where dreams go to die. We use 'someday' to justify our comfort zone, convincing ourselves that we are 'preparing' when we are actually procrastinating. 

**The Tactical Shift:**
* **Identify the Waiting Habit:** Recognize when you are using 'planning' as a proxy for 'doing.'
* **The 24-Hour Rule:** If you have an idea, you must take one physical step toward it within 24 hours.
* **Stop Preparing, Start Prototyping:** Perfectionism is the enemy. Release a 'Version 1.0' of your idea immediately to force accountability.

The realization here is that 'perfect timing' is a myth created by fear. You do not need to be ready; you need to be willing."""
    },
    {
        "bookId": book_id,
        "uid": str(uuid.uuid4()),
        "position": 2,
        "startTimeMs": 60000,
        "title": "Chapter 2: Stop Being a Professional Victim",
        "content": """### Chapter 2: Stop Being a Professional Victim

Many people outsource their destiny to external factors. By blaming the economy, their upbringing, or their boss, they abdicate their power. Stephenson introduces the concept of the 'Internal Locus of Control'—the belief that you are the primary driver of your life's outcomes.



**The Action Step:**
* **The Blame Audit:** For one week, keep a log of every time you blame someone else for a negative outcome. 
* **The Reframing Challenge:** For every entry, write down one thing *you* could have done differently, regardless of external circumstances.
* **Ownership as Freedom:** Understand that blaming others traps you in a state of helplessness; owning your mistakes is the only path to changing them."""
    },
    {
        "bookId": book_id,
        "uid": str(uuid.uuid4()),
        "position": 3,
        "startTimeMs": 120000,
        "title": "Chapter 3: Dismantling Your Internal Lies",
        "content": """### Chapter 3: Dismantling Your Internal Lies

We often operate based on 'Limiting Beliefs'—stories we adopted in childhood that no longer serve us. You may believe you are 'bad with money' or 'not a natural leader.' Stephenson classifies these as structural lies that protect us from the pain of failing.

**Deconstruction Techniques:**
1. **Name the Lie:** Identify the narrative (e.g., 'I’m too old to start a business').
2. **Find the Counter-Evidence:** List three real-world examples that prove this statement false.
3. **Rewrite the Script:** Replace the lie with an 'Action-Based Belief' (e.g., 'I have 30 years of experience, and I am learning the specific skills needed to launch this model')."""
    },
    {
        "bookId": book_id,
        "uid": str(uuid.uuid4()),
        "position": 4,
        "startTimeMs": 180000,
        "title": "Chapter 4: Fear as a Compass",
        "content": """### Chapter 4: Fear as a Compass

Fear is a biological signal. It is the body's way of saying, 'You are approaching a boundary.' Stephenson suggests that most people try to get rid of fear, whereas the 'sh\*t-making-happen' crowd learns to use it as a navigation tool. 

**Navigational Strategies:**
* **The Fear-Setting Exercise:** Write down your worst-case scenario. When you see it on paper, it often loses its paralyzing power.
* **The Comfort Threshold:** Map out your fears. The areas where you feel the most anxiety are the exact areas where your highest growth potential resides.
* **Action as the Antidote:** Whenever fear hits, immediately pair it with a small, concrete action step to break the cycle of rumination."""
    },
    {
        "bookId": book_id,
        "uid": str(uuid.uuid4()),
        "position": 5,
        "startTimeMs": 240000,
        "title": "Chapter 5: The Power of Radical Accountability",
        "content": """### Chapter 5: The Power of Radical Accountability

Accountability is the gap between a goal and a result. Most people are only accountable to themselves, which is why they frequently negotiate away their own promises.

**Building a Support Infrastructure:**
* **The Brutally Honest Peer:** Find someone who doesn't care about your feelings, but does care about your success.
* **Public Commitment:** State your goal on a timeline to your colleagues or family. 
* **The Cost of Failure:** Define a consequence for missing a milestone. When failure costs you something you value, you become significantly more consistent."""
    },
    {
        "bookId": book_id,
        "uid": str(uuid.uuid4()),
        "position": 6,
        "startTimeMs": 300000,
        "title": "Chapter 6: Prioritizing Your Purpose",
        "content": """### Chapter 6: Prioritizing Your Purpose

'Busy' is often just a lifestyle choice to avoid feeling overwhelmed by what matters. Stephenson forces you to categorize your tasks based on the '80/20 Rule' (Pareto Principle). 

**Execution Frameworks:**
* **The Purpose Audit:** List your top three goals. If a daily task does not contribute to one of those three, it is a distraction.
* **The 'No' Strategy:** You must say 'no' to 90% of requests to say 'yes' to the 10% that will change your life.
* **Deep Work Sprints:** Block 90 minutes of uninterrupted time for your primary goal before you open email or social media."""
    },
    {
        "bookId": book_id,
        "uid": str(uuid.uuid4()),
        "position": 7,
        "startTimeMs": 360000,
        "title": "Chapter 7: The Art of the Hard Conversation",
        "content": """### Chapter 7: The Art of the Hard Conversation

Avoiding discomfort is the fastest way to limit your professional and personal trajectory. Stephenson treats hard conversations (asking for a raise, setting a boundary) as 'energy leaks.' When you don't have the conversation, you lose energy ruminating about it.

**Tactics for Confrontation:**
* **The 'Facts Only' Script:** Strip emotion from the start. State the behavior and the impact.
* **The Silence Technique:** After asking a hard question or stating a boundary, remain silent. The person you are talking to will usually fill the space, often providing the agreement you need.
* **Outcome Detachment:** Accept that you cannot control the other person's reaction, only the clarity of your own communication."""
    },
    {
        "bookId": book_id,
        "uid": str(uuid.uuid4()),
        "position": 8,
        "startTimeMs": 420000,
        "title": "Chapter 8: Crushing the Perfectionist Traps",
        "content": """### Chapter 8: Crushing the Perfectionist Traps

Perfectionism is a disguise for the fear of judgment. It is the belief that 'if I keep working on this, I won't have to show it to people and risk them telling me it’s not good enough.' 

**Execution Hacks:**
* **The 80% Rule:** Commit to shipping your work when it is 80% 'perfect.' The remaining 20% should be determined by feedback from the market, not your own internal critique.
* **Iteration Cycles:** Adopt a 'Get it done, then make it better' workflow. 
* **The Failure Goal:** Set a goal to have a draft rejected. It shifts your mindset from 'avoiding error' to 'gathering data.'"""
    },
    {
        "bookId": book_id,
        "uid": str(uuid.uuid4()),
        "position": 9,
        "startTimeMs": 480000,
        "title": "Chapter 9: Master Your Morning Ritual",
        "content": """### Chapter 9: Master Your Morning Ritual

Stephenson emphasizes that you are the most impressionable version of yourself in the first 30 minutes of the day. If you check email first, you are reactive. If you check your goals first, you are proactive.

**The Ritual Framework:**
1. **Movement:** 5 minutes of physical engagement to jumpstart your physiology.
2. **Review:** Read your 'Definite Chief Aim' to prime your reticular activating system (the part of your brain that filters information).
3. **One Big Win:** Identify the most difficult task for the day and perform it before your first scheduled meeting."""
    },
    {
        "bookId": book_id,
        "uid": str(uuid.uuid4()),
        "position": 10,
        "startTimeMs": 540000,
        "title": "Chapter 10: Fail Forward and Fast",
        "content": """### Chapter 10: Fail Forward and Fast

Failure is not the absence of success; it is the prerequisite. Stephenson’s model of success is based on the 'Fail-Fast' method.

**Learning from Defeat:**
* **The Post-Mortem:** After every setback, ask: 'What did the data tell me that I didn't know before?'
* **Detaching from Identity:** When you fail, your *plan* failed, not *you*. 
* **The Velocity Metric:** The more frequently you try, the more frequently you will encounter success simply by law of averages."""
    },
    {
        "bookId": book_id,
        "uid": str(uuid.uuid4()),
        "position": 11,
        "startTimeMs": 600000,
        "title": "Chapter 11: The Economy of Energy",
        "content": """### Chapter 11: The Economy of Energy

Execution requires energy. If you are exhausted, your decision-making quality drops, and you will default to the path of least resistance (procrastination).

**Energy Management Rules:**
* **Sleep as Strategy:** It is not a luxury; it is the operating system update for your brain.
* **Decision Fatigue:** Reduce the number of small choices you make (what to wear, what to eat) to save your cognitive power for the work that matters.
* **Movement as Power:** Physical training is not for your aesthetics; it is for your mental capacity to sustain long-term focus."""
    },
    {
        "bookId": book_id,
        "uid": str(uuid.uuid4()),
        "position": 12,
        "startTimeMs": 660000,
        "title": "Chapter 12: Influence and Collaboration",
        "content": """### Chapter 12: Influence and Collaboration

No one makes significant progress entirely alone. Influence is about providing enough value to others that they *want* to see you succeed.

**Collaboration Tactics:**
* **The Value-First Approach:** Before asking for help, solve a problem for the person you want to network with.
* **Authentic Relationship Building:** People detect 'networking for gain' instantly. Focus on genuine curiosity about other people’s goals.
* **Leverage Networks:** Once you have provided value, respectfully ask for introductions or advice."""
    },
    {
        "bookId": book_id,
        "uid": str(uuid.uuid4()),
        "position": 13,
        "startTimeMs": 720000,
        "title": "Chapter 13: Staying in the Arena",
        "content": """### Chapter 13: Staying in the Arena

The 'arena' is where the work happens. It is uncomfortable, loud, and dangerous. Most people watch from the stands. Stephenson discusses the 'Plateau of Latent Potential'—the period where you are working hard but seeing no results.

**Endurance Tactics:**
* **Process over Outcome:** Fall in love with the daily habit, not the final result.
* **Emotional Anchors:** Remember why you started when the progress slows down.
* **The Long Game:** Remind yourself that a year of consistency is worth more than a month of intensity."""
    },
    {
        "bookId": book_id,
        "uid": str(uuid.uuid4()),
        "position": 14,
        "startTimeMs": 780000,
        "title": "Chapter 14: Living with Radical Purpose",
        "content": """### Chapter 14: Living with Radical Purpose

If your goal is just to make money, you will eventually quit. Stephenson ends by connecting high-level execution to legacy. 

**Living with Purpose:**
* **The 80-Year-Old Review:** Visualize yourself at the end of your life looking back. What do you want to have created? 
* **Daily Alignment:** Does your schedule today reflect the person you want to have been 40 years from now?
* **Legacy as a Motivator:** When the 'how-to' gets hard, the 'why' will carry you through."""
    }
]
        upload_books(firestore_db, book_content, book_data)

#         delete_by_book_id(
#     firestore_db,
#     "book_content",
#     "f791077f-d617-4a57-aace-c28b5b77055a"
# )
    except Exception as e:
        print(f"\n💥 Script execution failed: {e}")




        