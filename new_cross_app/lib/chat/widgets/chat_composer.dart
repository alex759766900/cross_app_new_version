import 'package:flutter/material.dart';
//import 'package:new_cross_app/chat/screens/chat_screen.dart';

Container buildChatComposer() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    color: Colors.white,
    height: 100,
    child: Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.emoji_emotions_outlined,
                    size: 28,
                  ),
                  onPressed: () {},
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Type your message ...',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        GestureDetector(
          onTap: () {
            // Do something when the CircleAvatar is tapped
            //addMessage();
            print('CircleAvatar tapped!');
          },
          child: const CircleAvatar(
            backgroundColor: Color(0xFF4CAF50),
            child: Icon(
              Icons.send,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
  );
}
