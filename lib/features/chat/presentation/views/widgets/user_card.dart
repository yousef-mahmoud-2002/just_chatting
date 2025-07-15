import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_chatting/constants.dart';
import 'package:just_chatting/features/auth/data/models/user_model.dart';
import 'package:just_chatting/features/chat/presentation/manager/chat/chat_cubit.dart';

class UserCard extends StatefulWidget {
  const UserCard({super.key, required this.userModel});

  final UserModel userModel;

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: kPrimaryColor.shade100,
      splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory,
      onTap: () {
        setState(() {
          if (isSelected) {
            context.read<ChatCubit>().membersIds.remove(widget.userModel.uid);
          } else {
            context.read<ChatCubit>().membersIds.add(widget.userModel.uid);
          }
          isSelected = !isSelected;
        });
      },
      child: Container(
        color: isSelected ? kPrimaryColor.shade100 : Colors.transparent,
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 23,
              backgroundColor: Colors.grey.shade300,
              backgroundImage: NetworkImage(widget.userModel.profileImage),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.userModel.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            isSelected
                ? const Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: Icon(
                      Icons.check_circle,
                      color: kPrimaryColor,
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
