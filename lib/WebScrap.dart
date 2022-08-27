import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';
import 'package:webscraping/product.dart';

class WebScrap extends StatefulWidget {
  const WebScrap({Key? key}) : super(key: key);

  @override
  _WebScrapState createState() => _WebScrapState();
}

class _WebScrapState extends State<WebScrap> {
  bool isLoading = false;
  List<ProductModel> data = [];

  Future getdata(var search) async {
    var a = "https://www.reliancedigital.in/search?q=$search";
    final url = Uri.parse(a);
    var response = await Dio().get(url.toString());
    dom.Document html = dom.Document.html(response.data);
    final titles = html
        .querySelectorAll('li > div > a > div > div > p')
        .map((e) => e.innerHtml.trim())
        .toList();

    final urls = html
        .querySelectorAll('li > div > a')
        .map((e) =>
            'https://www.reliancedigital.in${e.attributes['href']}') //#pl > div.pl__container > ul > li:nth-child(1) > div > a
        .toList();
    final imageUrl = html
        .querySelectorAll('div > a > div > div > div > div > img')
        .map((e) =>
            'https://www.reliancedigital.in${e.attributes['data-srcset']!}')
        .toList();
    final priceCurrencys = html
        .querySelectorAll(
            'div > a > div > div > div > div >  div > span > span:nth-child(1)')
        .map((e) => e.innerHtml.trim())
        .toList();
    final newPrice = html
        .querySelectorAll(
            'div > a > div > div > div > div >  div > span > span:nth-child(1)')
        .map((e) => e.innerHtml.trim())
        .toList();

    setState(() {
      data = List.generate(
          titles.length,
          (index) => ProductModel(
                name: titles[index],
                url: urls[index],
                currency: priceCurrencys[index],
                image: imageUrl[index],
                price: newPrice[index],
              ));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getdata("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Web Scraping"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    await getdata("iphone 13");
                    setState(() {
                      isLoading = false;
                    });
                  },
                  child: Text('Scrap Data')),
              TextField(
                onChanged: (v) {
                  getdata(v);
                },
                onSubmitted: (v) {},
                onEditingComplete: () {
                  getdata("iphone 13");
                },
                enableSuggestions: true,
                decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.search),
                    border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 20,
              ),
              isLoading
                  ? const CircularProgressIndicator()
                  : Expanded(
                      child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            final model = data[index];
                            return Card(
                              elevation: 4,
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Image.network(
                                          model.image!,
                                          width: 50,
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                          flex: 5,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: Text(
                                                  data[index].name.toString(),
                                                  textAlign: TextAlign.left,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                      "Price-${data[index].price.toString()}"),
                                                ],
                                              ),
                                            ],
                                          )),
                                      Expanded(
                                          flex: 1,
                                          child: InkWell(
                                            onTap: () async {
                                              final Uri _url = Uri.parse(
                                                  "${data[index].url}");
                                              await launchUrl(_url,
                                                  mode: LaunchMode
                                                      .externalApplication);
                                            },
                                            child: const Chip(
                                              label: Text(
                                                "View",
                                                style: TextStyle(fontSize: 10),
                                              ),
                                            ),
                                          ))
                                    ],
                                  )),
                            );
                          }),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
