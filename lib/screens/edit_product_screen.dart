import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const String routeName = '/product_edit';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editProduct = Product(
      id: "",
      title: "title",
      description: "description",
      price: 0,
      imageUrl: "imageUrl");

  var isInit = true;
  var initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      Map<String, dynamic> map =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

      if (map['edit'] == true) {
        final productId = map['id'];
        if (productId != null) {
          _editProduct =
              Provider.of<Products>(context, listen: false).findById(productId);

          initValues = {
            'title': _editProduct.title,
            'description': _editProduct.description,
            'price': _editProduct.price.toString(),
            'imageUrl': _editProduct.imageUrl
          };
          _imageUrlController.text = _editProduct.imageUrl;
        }
      }
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void saveForm() {
    var isValid = _form.currentState!.validate();
    if (isValid) {
      _form.currentState!.save();

      print(_editProduct.title + " " + _editProduct.description);
      if (!_editProduct.id.isEmpty) {
        Provider.of<Products>(context, listen: false)
            .updateProduct(_editProduct.id, _editProduct);
      } else {
        Provider.of<Products>(context, listen: false).addProduct(_editProduct);
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [IconButton(onPressed: saveForm, icon: Icon(Icons.save))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _form,
            child: ListView(
              children: [
                TextFormField(
                  initialValue: initValues.isEmpty ? '' : initValues['title'],
                  decoration: InputDecoration(
                    labelText: 'Title',
                  ),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  onSaved: (value) {
                    _editProduct = Product(
                        id: _editProduct.id,
                        title: value!,
                        description: _editProduct.description,
                        price: _editProduct.price,
                        imageUrl: _editProduct.imageUrl,
                        isFavorite: _editProduct.isFavorite);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Provide a value';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: initValues.isEmpty ? '' : initValues['price'],
                  decoration: InputDecoration(
                    labelText: 'Price',
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  onSaved: (value) {
                    _editProduct = Product(
                        id: _editProduct.id,
                        title: _editProduct.title,
                        description: _editProduct.description,
                        price: double.parse(value!),
                        imageUrl: _editProduct.imageUrl,
                        isFavorite: _editProduct.isFavorite);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Provide a value';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please ener a valid number';
                    }
                    if (double.parse(value) <= 0) {
                      return 'Please enter number greater than zero';
                    }

                    return null;
                  },
                ),
                TextFormField(
                  initialValue:
                      initValues.isEmpty ? '' : initValues['description'],
                  decoration: InputDecoration(
                    labelText: 'Description',
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  focusNode: _descriptionFocusNode,
                  onSaved: (value) {
                    _editProduct = Product(
                        id: _editProduct.id,
                        title: _editProduct.title,
                        description: value!,
                        price: _editProduct.price,
                        imageUrl: _editProduct.imageUrl,
                        isFavorite: _editProduct.isFavorite);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Provide a value';
                    }
                    return null;
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 8, right: 10),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                      ),
                      child: _imageUrlController.text.isEmpty
                          ? Text('Enter a Url!')
                          : FittedBox(
                              child: Image.network(_imageUrlController.text)),
                    ),
                    Expanded(
                        child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (_) {
                        saveForm();
                      },
                      onEditingComplete: () {
                        setState(() {});
                      },
                      onSaved: (value) {
                        _editProduct = Product(
                            id: _editProduct.id,
                            title: _editProduct.title,
                            description: _editProduct.description,
                            price: _editProduct.price,
                            imageUrl: value!,
                            isFavorite: _editProduct.isFavorite);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Provide a value';
                        }

                        return null;
                      },
                    )),
                  ],
                )
              ],
            )),
      ),
    );
  }
}
