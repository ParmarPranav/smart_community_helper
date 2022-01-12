import 'package:flutter/material.dart';

import '../models/local_permission.dart';
import '../models/permission.dart';
import '../models/permission_group.dart';

class PermissionGroupItemWidget extends StatefulWidget {
  final PermissionGroup permissionGroup;
  final bool isGroupSelected;
  final List<LocalPermission> localPermissionList;
  final ValueChanged<PermissionGroup> onPermissionGroupAdded;
  final ValueChanged<PermissionGroup> onPermissionGroupRemoved;
  final ValueChanged<Permission> onPermissionAdded;
  final ValueChanged<Permission> onPermissionRemoved;

  PermissionGroupItemWidget({
    required this.permissionGroup,
    required this.isGroupSelected,
    required this.localPermissionList,
    required this.onPermissionGroupAdded,
    required this.onPermissionGroupRemoved,
    required this.onPermissionAdded,
    required this.onPermissionRemoved,
  });

  @override
  _PermissionGroupItemWidgetState createState() => _PermissionGroupItemWidgetState();
}

class _PermissionGroupItemWidgetState extends State<PermissionGroupItemWidget> {
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.permissionGroup.permissions.length > 0
        ? ExpansionTile(
            initiallyExpanded: true,
            title: Row(
              children: [
                Checkbox(
                  value: widget.isGroupSelected,
                  onChanged: (value) {
                    if (value!) {
                      widget.onPermissionGroupAdded(widget.permissionGroup);
                    } else {
                      widget.onPermissionGroupRemoved(widget.permissionGroup);
                    }
                  },
                ),
                SizedBox(width: 10),
                Text(
                  widget.permissionGroup.name.replaceAll('-', ' '),
                  style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            childrenPadding: EdgeInsets.only(right: 8.0),
            children: widget.permissionGroup.permissions.map((permission) {
              return Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 50),
                    child: Row(
                      children: [
                        Checkbox(
                          value: widget.localPermissionList.any((item) => item.permissionId == permission.id),
                          onChanged: (value) {
                            if (value!) {
                              widget.onPermissionAdded(permission);
                            } else {
                              widget.onPermissionRemoved(permission);
                            }
                          },
                        ),
                        SizedBox(width: 10),
                        Text(permission.name.replaceAll('-', ' ')),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              );
            }).toList(),
          )
        : ListTile(
            title: Row(
              children: [
                Checkbox(
                  value: widget.isGroupSelected,
                  onChanged: (value) {
                    if (value!) {
                      widget.onPermissionGroupAdded(widget.permissionGroup);
                    } else {
                      widget.onPermissionGroupRemoved(widget.permissionGroup);
                    }
                  },
                ),
                SizedBox(width: 10),
                Text(
                  widget.permissionGroup.name.replaceAll('-', ' '),
                  style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
  }
}
