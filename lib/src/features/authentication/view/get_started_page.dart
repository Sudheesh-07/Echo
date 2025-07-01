// ignore_for_file: deprecated_member_use
import 'package:echo/src/core/extensions/context_extension.dart';
import 'package:echo/src/core/extensions/image_extensions.dart';
import 'package:echo/src/core/routes/app_routes.dart';
import 'package:echo/src/core/utils/widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

/// This is the get started page
class GetStartedPage extends StatefulWidget {
  /// Constructor
  const GetStartedPage({super.key});

  @override
  State<GetStartedPage> createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image:
                  context.theme == Brightness.dark
                      ? const AssetImage(AppImages.loginBgDark)
                      : const AssetImage(AppImages.loginBgLight),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                if (context.theme == Brightness.dark)
                  Colors.black.withOpacity(0.2)
                else
                  context.colorScheme.primary.withOpacity(0.2),
                if (context.theme == Brightness.dark)
                  Colors.black.withOpacity(0.7)
                else
                  context.colorScheme.primary.withOpacity(0.7),
              ],
            ),
          ),
        ),
        Center(
          child: SizedBox(
            height: 800,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                children: <Widget>[
                  const Gap(70),
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF4853c6),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: ClipOval(
                          child: Image.asset(
                            AppImages.appLogo,
                            fit:
                                BoxFit
                                    // ignore: lines_longer_than_80_chars
                                    .cover, // Ensures the image fills the circle
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Gap(10),
                  Text(
                    'Echo',
                    style: context.textTheme.displayLarge?.copyWith(
                      color: const Color(0xFF4853c6),
                      fontWeight: FontWeight.bold,
                      fontSize: 64,
                    ),
                  ),
                  const Gap(20),
                  Text(
                    "Low key bored? \n Echo's got drama!",
                    textAlign: TextAlign.center,
                    style: context.textTheme.displayLarge?.copyWith(
                      fontSize: 30,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    // ignore: lines_longer_than_80_chars
                    'Post your thoughts, catch the campus buzz, \n or just vibe in silence. It is here, where \n everything echoes',
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyLarge,
                  ),
                  const Gap(20),
                  ElevatedButton(
                    onPressed:
                        () => context.push(
                          AppRoutes.authentication,
                          extra: false,
                        ),
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      shadowColor: context.colorScheme.primary,
                      backgroundColor: Colors.white,
                      fixedSize: const Size(350, 50),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      'Register',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: context.colorScheme.primary,
                      ),
                    ),
                  ),
                  const Gap(15),
                  EchoButton(
                    label: 'Log In',
                    onPressed:
                        () =>
                            context.push(AppRoutes.authentication, extra: true),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
