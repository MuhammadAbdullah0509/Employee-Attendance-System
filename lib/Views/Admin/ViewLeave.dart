import 'package:attendance_system/Resources/CustomSize.dart';
import 'package:attendance_system/Services/ApiHandler.dart';
import 'package:attendance_system/Utilis/FlushBar.dart';
import 'package:flutter/material.dart';

class ViewLeave extends StatefulWidget {
  const ViewLeave({super.key});

  @override
  State<ViewLeave> createState() => _ViewLeaveState();
}

class _ViewLeaveState extends State<ViewLeave> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: FutureBuilder(
            future: ApiHandler().getLeave(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.teal.withOpacity(0.3),
                      child: ListTile(
                          title: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(snapshot.data![index].name.toString()),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  int code = await ApiHandler().leaves(
                                      int.parse(
                                          snapshot.data![index].id.toString()),
                                      "Present",snapshot.data![index].date.toString());
                                  if (context.mounted) {
                                    if (code == 200) {
                                      Utilis.flushBarMessage(
                                          "Accepted", context);
                                    } else {
                                      Utilis.flushBarMessage("Error", context);
                                    }
                                  }
                                  setState((){});
                                },
                                child: const Center(
                                  child: Text("Accept"),
                                ),
                              ),
                              SizedBox(
                                width: CustomSize().customWidth(context) / 25,
                              ),
                              ElevatedButton(
                                  onPressed: () async {
                                    int code = await ApiHandler().leaves(
                                        int.parse(snapshot.data![index].id
                                            .toString()),
                                        "Absent",snapshot.data![index].date.toString());
                                    if (context.mounted) {
                                      if (code == 200) {
                                        Utilis.flushBarMessage(
                                            "Rejected", context);
                                      } else {
                                        Utilis.flushBarMessage(
                                            "Error", context);
                                      }
                                    }
                                    setState(() {

                                    });
                                  },
                                  child: const Center(
                                    child: Text("Reject"),
                                  ))
                            ],
                          )
                        ],
                      ),
                          subtitle:Text(snapshot.data![index].date.toString()),
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )),
        ],
      ),
    );
  }
}
