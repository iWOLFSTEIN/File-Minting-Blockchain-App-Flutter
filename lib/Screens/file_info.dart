import 'package:file_minting_app/Constants/private_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

import '../Constants/networking_fields.dart';
import '../Services/smart_contract.dart';

class FileInfo extends StatefulWidget {
  FileInfo({Key? key, this.inputFileMetadata, this.inputFileHashCode})
      : super(key: key);

  var inputFileMetadata;
  var inputFileHashCode;

  @override
  State<FileInfo> createState() => _FileInfoState();
}

class _FileInfoState extends State<FileInfo> {
  var credentials;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    extractCredentials();
  }

  extractCredentials() async {
    var myCredentials = await ethClient.credentialsFromPrivateKey(privateKey);

    setState(() {
      credentials = myCredentials;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("File Information"),
          backgroundColor: Colors.green.shade300),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   "File Information",
                //   style: TextStyle(
                //       color: Colors.black.withOpacity(0.7),
                //       fontWeight: FontWeight.w600,
                //       fontSize: 26),
                // ),
                // const SizedBox(
                //   height: 15,
                // ),
                info(
                    heading: "File Name: ",
                    value: "${widget.inputFileMetadata.name}"),
                info(
                    heading: "File Bytes: ",
                    value: "${widget.inputFileMetadata.bytes}"),
                info(
                    heading: "File Size: ",
                    value: "${widget.inputFileMetadata.size}"),
                info(
                    heading: "File Extension: ",
                    value: "${widget.inputFileMetadata.extension}"),
                info(
                    heading: "File Path: ",
                    value: "${widget.inputFileMetadata.path}"),
                info(
                    heading: "File Hash: ",
                    value: "${widget.inputFileHashCode}"),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Container(
              color: Colors.green.shade100,
              height: 45,
              width: 365,
              child: TextButton(
                  onPressed: () async {
                    print(widget.inputFileHashCode);
                    var funcResult = await query_transaction(
                      "mintFile",
                      [
                        credentials.address,
                        widget.inputFileHashCode,
                      ],
                      credentials: credentials,
                    );
                    print("printing ...");
                    print(funcResult);

                    // setState(() {
                    //   isExpanded = false;
                    //   inputFile = null;
                    //   inputFileMetadata = null;
                    //   inputFileHashCode = null;
                    // });

                    // var myMintFiles = await query(
                    //     'myMintFiles', [credentials.address],
                    //     ethClient: ethClient);
                    // print(myMintFiles);
                    // print('total minted files are: ' +
                    //     myMintFiles[0].length.toString());

                    Navigator.pop(context);
                  },
                  child: Text(
                    "Mint",
                    style: TextStyle(color: Colors.green.withOpacity(0.7)),
                  )),
            ),
          )
        ],
      ),
    );
  }

  Padding info({heading, value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Wrap(
        children: [
          Text(
            heading,
            style: TextStyle(
                color: Colors.green.withOpacity(0.7),
                fontWeight: FontWeight.w600,
                fontSize: 17),
          ),
          Text(
            value,
            style: TextStyle(color: Colors.black.withOpacity(0.4)),
          ),
        ],
      ),
    );
  }
}
