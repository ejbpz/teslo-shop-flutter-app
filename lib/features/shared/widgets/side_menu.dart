import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/shared/shared.dart';

class SideMenu extends ConsumerStatefulWidget {

  final GlobalKey<ScaffoldState> scaffoldKey;

  const SideMenu({
    super.key, 
    required this.scaffoldKey
  });

  @override
  ConsumerState<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends ConsumerState<SideMenu> {

  int navDrawerIndex = 0;

  @override
  Widget build(BuildContext context) {
    final hasNotch = MediaQuery.of(context).viewPadding.top > 35;
    final size = MediaQuery.of(context).size;
    final textStyles = Theme.of(context).textTheme;
    final name = ref.watch(authProvider).user?.fullName;

    return NavigationDrawer(
      elevation: 1,
      selectedIndex: navDrawerIndex,
      onDestinationSelected: (value) {
        setState(() => navDrawerIndex = value);
        if(value == 1) context.push('/product/new');
        widget.scaffoldKey.currentState?.closeDrawer();

      },
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20, hasNotch ? 0 : 20, 16, 0),
          child: Text('Welcome', style: textStyles.titleMedium ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 16, 20),
          child: Text(name ?? '', style: textStyles.titleSmall),
        ),

        const NavigationDrawerDestination(
            icon: Icon( Icons.store_mall_directory_outlined), 
            selectedIcon: Icon(Icons.store_mall_directory),
            label: Text( 'All Products' ),
        ),

        const Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
          child: Divider(),
        ),

        const NavigationDrawerDestination(
            icon: Icon(Icons.add_business_outlined), 
            selectedIcon: Icon(Icons.add_business_rounded), 
            label: Text('New Product'),
            
        ),

        SizedBox(
          height: size.height * 0.65,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: Container()),
          
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomFilledButton(
                  onPressed: () {
                    ref.read(authProvider.notifier).logout();
                    context.go('/login');
                  },
                  text: 'Logout'
                ),
              ),
          
            ],
          ),
        )
      ]
    );
  }
}