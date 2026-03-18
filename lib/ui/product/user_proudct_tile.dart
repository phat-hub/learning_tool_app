import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screen.dart';

class UserProudctTile extends StatefulWidget {
  const UserProudctTile(
    this.product, {
    super.key,
  });

  final Product product;

  @override
  State<UserProudctTile> createState() => _UserProudctTileState();
}

class _UserProudctTileState extends State<UserProudctTile> {
  bool isCheck = false;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.product.title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(widget.product.imageURL1),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            EditUserProductButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  '/edit_product',
                  arguments: widget.product.id,
                );
              },
            ),
            DeleteUserProductButton(
              onPressed: () {
                context
                    .read<ProductManager>()
                    .deleteProduct(widget.product.id!);
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(
                        content: Text(
                      'Xóa sản phẩm thành công.',
                      textAlign: TextAlign.center,
                    )),
                  );
              },
            ),
            // Checkbox(
            //   value: isCheck,
            //   onChanged: (newValue) {
            //     setState(() {
            //       isCheck = newValue!;
            //     });
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}

class EditUserProductButton extends StatelessWidget {
  const EditUserProductButton({
    super.key,
    this.onPressed,
  });

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.edit),
      onPressed: onPressed,
      color: Theme.of(context).colorScheme.primary,
    );
  }
}

class DeleteUserProductButton extends StatelessWidget {
  const DeleteUserProductButton({
    super.key,
    this.onPressed,
  });

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.delete),
      color: Theme.of(context).colorScheme.error,
    );
  }
}
