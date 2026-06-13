import 'package:flutter/material.dart';



class BookMetadata extends StatelessWidget {
  
  const BookMetadata({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildMetaItem(
            context: context,
            icon: Icons.menu_outlined,
            iconColor: Colors.grey,
            title: "10 key points",
            label: "",
          ),
          const SizedBox(width: 20,),
          _buildMetaItem(
            context: context,
            icon: Icons.timer_outlined,
            iconColor: Colors.grey,
            title: "15 min",
            label: "",
          ),
          const SizedBox(width: 20,),
          
          _buildMetaItem(
            context: context,
            icon: Icons.star,
            iconColor: Colors.grey,
            title: "4.7",
            label: "Rate",
          ),
        ],
      ),
    );
  }
}


Widget _buildMetaItem({
  required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String label,

  }) {
    return Row(
      mainAxisSize: MainAxisSize.min, // Hugs content tightly
      children: [
        Icon(icon, color: iconColor, size: 22),
        const SizedBox(height: 6,width: 6,),
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 13
            ),
        ),
        const SizedBox(height: 2,width: 6,),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 13,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
