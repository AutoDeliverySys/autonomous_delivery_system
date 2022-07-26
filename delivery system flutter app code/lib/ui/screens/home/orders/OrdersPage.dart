// ignore_for_file: file_names

import 'package:delivery_system/controller/logic/database/Database.dart';
import 'package:delivery_system/controller/shared/Order.dart';
import 'package:delivery_system/ui/screens/home/orders/OrdersPageFunctions.dart';
import 'package:delivery_system/ui/shared/constants/Components.dart' as components;
import 'package:delivery_system/ui/shared/constants/Constants.dart';
import '../../../cards/Orders.dart';
import '../../../shared/constants/modes.dart';
import 'package:flutter/material.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  OrdersPageFunctions? funs;

  @override
  Widget build(BuildContext context) {
    funs ??= OrdersPageFunctions(context: context, setState: setState);
    OrdersPageFunctions functions = funs!;

    List<Order> orders = getOrders();
    int ordersNum = orders.length;
    int i = 0;
    return Scaffold(
      key: functions.scaffoldKey,
      backgroundColor: modeColors[0][0],
      appBar: components.appBar("Orders",
          leadingIcon: Icons.account_circle_rounded,
          leadingIconPressed: () => Navigator.pushNamed(context, routePageProfile),
          actions: [
            components.AppBarAction(
              iconData: Icons.map,
              function: () => Navigator.pushNamed(context, routePageMap),
            )
          ]),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: functions.refresh,
            backgroundColor: modeColors[1][1],
            child: const Icon(Icons.refresh),
            tooltip: "refresh",
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: functions.floatingButtonFunction,
            backgroundColor: modeColors[1][1],
            child: Icon(functions.actionButtonIcon),
            tooltip: "new request",
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
        child: ordersNum > 0
            ? ListView.separated(
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) => orderItem(
                  context,
                  username: orders[i].anotherUsername,
                  backColor: modeColors[0][1],
                  suffixIcon: (orders[i].status == "cancelled" || orders[i].status == "done")
                      ? Icons.delete_forever
                      : Icons.close,
                  color: modeColors[2][1],
                  iconAction: (order) {
                    setState(() {
                      if (order.status == "cancelled" || order.status == "done") {
                        functions.deleteOrder(order);
                      } else {
                        functions.cancelOrder(order);
                      }
                    });
                  },
                  order: orders[i++],
                ),
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemCount: ordersNum,
              )
            : const Center(
                child: Text(
                  "Create new order",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
      ),
    );
  }
}
