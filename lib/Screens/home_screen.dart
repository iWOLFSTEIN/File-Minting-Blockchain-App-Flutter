import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_minting_app/.g.dart';
import 'package:convert/convert.dart';

// import 'package:blockchain_copyrights/json_to_dart.dart';
import 'package:crypto/crypto.dart';
import 'package:file_minting_app/Constants/private_keys.dart';
import 'package:file_minting_app/Screens/file_info.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

import '../Constants/networking_fields.dart';
import '../Services/smart_contract.dart';
// import 'package:blockchain_copyrights/copyright.abi.json' as ;

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var credentials;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    extractCredentials();
  }

  extractCredentials() async {
    credentials = await ethClient.credentialsFromPrivateKey(privateKey);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    var height = MediaQuery.of(context).size.height;

    // var myMintFiles = await query(
    //                     'myMintFiles', [credentials.address],
    //                     ethClient: ethClient);
    return Scaffold(
        appBar:
            AppBar(title: Text("Home"), backgroundColor: Colors.green.shade300),
        backgroundColor: Colors.white,
        body: Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: InkWell(
                      onTap: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles();

                        if (result != null) {
                          File file = File(result.files.single.path!);
                          var metadata = result.files.first;
                          var fileHashCode = await generateFileHash(file);

                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return FileInfo(
                              inputFileMetadata: metadata,
                              inputFileHashCode: fileHashCode,
                            );
                          }));
                        } else {
                          // User canceled the picker
                        }
                      },
                      child: Container(
                          height: 100,
                          // width: 365,
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Click to select a file",
                                    style: TextStyle(
                                        color: Colors.green.withOpacity(0.7),
                                        fontSize: 18),
                                  ),
                                  Expanded(child: SizedBox()),
                                  Icon(Icons.file_copy_outlined,
                                      color: Colors.green.withOpacity(0.7)),
                                ],
                              ),
                              Wrap(
                                children: [
                                  Text(
                                    "File's hash will be minted against your wallet address",
                                    style: TextStyle(
                                        color: Colors.green.withOpacity(0.5),
                                        fontSize: 15),
                                  ),
                                ],
                              ),
                            ],
                          )),
                    ),
                  ),
                  if (credentials != null)
                    FutureBuilder(
                        future: query('myMintFiles', [credentials.address]),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Container();
                          }

                          List<dynamic> snapshotData = snapshot.data as List;
                          print(snapshotData[0].length);
                          List<Widget> widgetsList = [];
                          for (var i in snapshotData[0]) {
                            i = hex.encode(i);
                            var widget = Padding(
                              padding: EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                        // color: Colors.orange,
                                        width: width * 70 / 100,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: Text(
                                          i.toString(),
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 16),
                                        )),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Icon(
                                    Icons.key,
                                    color: Colors.grey,
                                  )
                                ],
                              ),
                            );
                            widgetsList.add(widget);
                          }

                          return Expanded(
                              child: SingleChildScrollView(
                            child: Column(
                              children: widgetsList,
                            ),
                          ));
                        })
                ]),
          ),
        ));
  }

  generateFileHash(File file) async {
    var bytesArray = await file.readAsBytes();
    Digest digest = sha256.convert(bytesArray);
    // return digest.toString();
    return digest.bytes;
  }
}
