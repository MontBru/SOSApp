
import 'dart:html';

import 'package:flutter/material.dart';

class Surchbar_ extends StatefulWidget {
  const Surchbar_({super.key});

  @override
  State<Surchbar_> createState() => _Surchbar_State();
}

class _Surchbar_State extends State<Surchbar_> 
{
 /// final TextEditingController friends = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return 
       Container(
        margin: EdgeInsets.only(left:100 , top:10 , right:100 ,bottom: 0),
        //color: Colors.amber,
        child: TextField(
       // controller: friends,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          labelText: "Search friends",
          filled: true,
          labelStyle: const TextStyle(
            color: Colors.black
          ),
        
          fillColor: Colors.black12,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none
          )
        ),
      ),
      );
      
      
    
  }
}