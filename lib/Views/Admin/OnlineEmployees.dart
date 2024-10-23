

import 'package:attendance_system/Services/ApiHandler.dart';
import 'package:flutter/material.dart';

class OnlineEmployees extends StatelessWidget {
  const OnlineEmployees({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: ApiHandler().getOnlineEmployees(),
              builder: (context, snapshot) {
                if(snapshot.hasData)
                {
                  return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.teal.withOpacity(0.3),
                        child: ListTile(
                            title:Text(snapshot.data![index].toString())),
                      );
                    },);
                }else
                {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
            },),
          )
        ],
      ),
    );
  }
}
