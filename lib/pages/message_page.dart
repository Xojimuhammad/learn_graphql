import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/message_model.dart';
import '../services/graphql_service.dart';


class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  String username = "Muhammadjon";
  List<Message> list = [];
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    getAllMessage();
  }

  void getAllMessage() async {
    var result = await GraphQLService.QUERY(
        GraphQLService.queryMessages(), GraphQLService.variableEmpty);

    if (result != null) {
      list = messageFromJson(result);
      setState(() {});
    }
  }

  void sendMessage() async {
    String message = controller.text.trim();
    var result = await GraphQLService.MUTATION(GraphQLService.mutationMessage(),
        GraphQLService.variableInsertMessage(username, message));

    if (result) {
      debugPrint("Success!");
      controller.clear();
      getAllMessage();
    } else {
      debugPrint("Error!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        centerTitle: true,
        title: const Text("Flutter B17 Messenger"),
    ),body: Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: list.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var message = list[index];
              if (username == message.username) {
                return Row(
                  children: [
                    const Expanded(child: SizedBox.shrink()),
                    Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.lightGreenAccent[200],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                          )),
                      child: Text(
                        "${message.username}: ${message.message}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                );
              }
              return Row(
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.lightBlueAccent[200],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        )),
                    child: Text(
                      "${message.username}: ${message.message}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 4,
                  ),
                ],
              );
            },
          ),
        ),
        Container(
          height: 80,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          color: Colors.white,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  height: 45,
                  alignment: Alignment.center,
                  child: TextField(
                    controller: controller,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                        hintText: "Write message ...",
                        border: InputBorder.none),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              IconButton(
                onPressed: sendMessage,
                icon: const Icon(CupertinoIcons.up_arrow),
              ),
            ],
          ),
        ),
      ],
    ),
    );
  }
}