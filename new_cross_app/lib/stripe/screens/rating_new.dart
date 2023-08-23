import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';



void main() {
  runApp(Rating());
}

class Rating extends StatelessWidget {
  TextEditingController _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Rating Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Rate Your Service'),
        ),
      body: Padding(padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Text(
              'How was your experience with the service?',
              style: TextStyle(fontSize: 30.0),
            ),
            SizedBox(height: 10.0),
            Text(
              'Tom',
              style: TextStyle(fontSize: 15.0),
            ),
            Container(height: 5.0),
            Container(
              child: Row(
                children:[
                Icon(Icons.star,
                    size: 15.0,
                    color: Colors.amber),
                Text(
                '4.94',
                style: TextStyle(fontSize: 15.0),
              ),])),
            Container(height: 15.0),
            Divider(height: 0.0,indent: 10.0,color: Colors.black),
            Container(height: 15.0),
            Text(
            'Rate your experience',
            style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 10.0),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
              },
            ),
            SizedBox(height: 20.0),
            Text(
              'Rate your tradie',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 10.0),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
              },
            ),
            SizedBox(height: 20.0),
            Text(
              'Leave a comment',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                hintText: 'Write a review',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
            ),
            Container(height: 15.0),
            Divider(height: 0.0,indent: 10.0,color: Colors.black),
            Container(height: 15.0),
            ElevatedButton(
              onPressed: () {
                String comment = _textEditingController.text.trim();
                // TODO: submit rating and comment to backend
              },
              child: Text('Submit'),
            ),
          ],
      ),
      ),
    ),
    );

    throw UnimplementedError();
  }

}