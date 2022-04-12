import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/products.dart';

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({Key? key}) : super(key: key);

  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // _imageUrlFocusNode.addListener(
    // função anonima -> () { print('mudou'); }
    //);  or
    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  /**
   * Recuperando o argumento passado no edit do product_item para
   * o product_form.
   */
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final productArg = ModalRoute.of(context)!.settings.arguments;
      if (productArg != null) {
        final product = productArg as Product;
        _formData['id'] = product.id;
        _formData['title'] = product.title;
        _formData['price'] = product.price;
        _formData['description'] = product.description;
        _formData['imageUrl'] = product.imageUrl;

        _imageUrlController.text = _formData['imageUrl'].toString();
      } else {
        _formData['id'] = '';
        _formData['title'] = '';
        _formData['price'] = '';
        _formData['description'] = '';
        _formData['imageUrl'] = '';
      }
    }
  }

  void _updateImageUrl() {
    if (isValidUrl(_imageUrlController.text)) {
      print('mudou url imager');
      setState(() {});
    }
  }

  bool isValidUrl(String url) {
    return url.toLowerCase().startsWith(RegExp('https?:\/\/')) ||
        (url.toLowerCase().endsWith('.png') ||
            url.toLowerCase().endsWith('.jpg') ||
            url.toLowerCase().endsWith('.jpeg'));
  }

  void _saveForm() async {
    var isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    _form.currentState!.save();
    print(_formData.values);
    final product = Product(
      id: _formData['id'] as String,
      title: _formData['title'] as String,
      description: _formData['description'] as String,
      price: _formData['price'] as double,
      imageUrl: _formData['imageUrl'] as String,
      isFavorite: false,
    );

    setState(() {
      _isLoading = true;
    });

    final provider = Provider.of<Products>(context, listen: false);
    if (product.id.trim().isEmpty) {
      try {
        await provider.addProduct(product);
        Navigator.of(context).pop();
      } catch (error) {
        showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Ocorreu um erro!"),
            content: Text("Ocorreu um erro ao salvar o produto."),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      provider.updateProduct(product);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário de Produto'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveForm();
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _formData['title'].toString(),
                      decoration: InputDecoration(label: Text('Titulo')),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) => _formData['title'] = value!,
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return 'Informe um título válido.';
                        }
                        if (value.trim().length < 3) {
                          return 'Informe pelo menos 3 letras';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['price'].toString(),
                      decoration: InputDecoration(label: Text('Preço')),
                      focusNode: _priceFocusNode,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (value) =>
                          _formData['price'] = double.parse(value ?? '0.0'),
                    ),
                    TextFormField(
                      initialValue: _formData['description'] as String,
                      decoration: InputDecoration(label: Text('Descrição')),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      onSaved: (value) => _formData['description'] = value!,
                      validator: (value) {
                        print("valor ${value}");
                        bool empty = value!.trim().isEmpty;
                        if (empty) {
                          return 'Informe um Preço válido!';
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration:
                                InputDecoration(label: Text('Url da Imagem')),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            focusNode: _imageUrlFocusNode,
                            controller: _imageUrlController,
                            onSaved: (value) => _formData['imageUrl'] = value!,
                            validator: (value) {
                              bool emptyUrl = value!.trim().isEmpty;
                              if (emptyUrl || !isValidUrl(value)) {
                                return 'Informe uma URL válida!';
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                          ),
                        ),
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(
                            top: 8,
                            left: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: _imageUrlController.text.isEmpty
                              ? Text('Informe a Url')
                              : Image.network(
                                  _imageUrlController.text,
                                  fit: BoxFit.cover,
                                ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
