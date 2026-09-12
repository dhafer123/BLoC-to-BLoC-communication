import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/connectivity/presentation/bloc/connectivity_bloc.dart';
import 'features/checkout/presentation/bloc/checkout_bloc.dart';
import 'features/shelf/presentation/bloc/shelf_bloc.dart';
import 'features/shelf/presentation/pages/home_page.dart';

class ShelfApp extends StatelessWidget {
  const ShelfApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Shelf',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    home: MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AuthBloc>()..add(AuthStarted())),
        BlocProvider(
          create: (_) => getIt<ConnectivityBloc>()..add(ConnectivityStarted()),
        ),
        BlocProvider(
          create: (context) =>
              getIt<ShelfBloc>(param1: context.read<AuthBloc>())
                ..add(ShelfLoaded()),
        ),
        BlocProvider(
          create: (context) => CheckoutBloc(
            shelfBloc: context.read<ShelfBloc>(),
            connectivityBloc: context.read<ConnectivityBloc>(),
          ),
        ),
      ],
      child: const HomePage(),
    ),
  );
}
