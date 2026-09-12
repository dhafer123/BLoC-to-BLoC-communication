import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../checkout/presentation/bloc/checkout_bloc.dart';
import '../../../connectivity/presentation/bloc/connectivity_bloc.dart';
import '../../domain/entities/book.dart';
import '../bloc/shelf_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final columns = width > 900
        ? 4
        : width > 620
        ? 3
        : 2;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _Header(columns: columns)),
            SliverToBoxAdapter(child: _StatusStrip()),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              sliver: SliverToBoxAdapter(child: _Intro()),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: BlocBuilder<ShelfBloc, List<Book>>(
                builder: (context, shelf) {
                  final catalog = context.read<ShelfBloc>().catalog;
                  return SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.68,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _BookCard(book: catalog[index]),
                      childCount: catalog.length,
                    ),
                  );
                },
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
      ),
      bottomNavigationBar: const _CheckoutBar(),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.columns});

  final int columns;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
    child: Row(
      children: [
        Text(
          'SHELF',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
        const Spacer(),
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final signedIn = state is AuthSignedIn;
            return Row(
              children: [
                Text(
                  signedIn
                      ? 'Hi, ${state.user.name.split(' ').first}'
                      : 'Guest reader',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(width: 12),
                IconButton(
                  tooltip: signedIn ? 'Sign out' : 'Sign in',
                  onPressed: () => context.read<AuthBloc>().add(
                    signedIn ? AuthSignOutRequested() : AuthSignInRequested(),
                  ),
                  icon: Icon(
                    signedIn ? Icons.logout_rounded : Icons.login_rounded,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    ),
  );
}

class _StatusStrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocBuilder<ConnectivityBloc, bool>(
    builder: (context, isOnline) => AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isOnline ? const Color(0xFFDCEFE4) : const Color(0xFFF7D7CE),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            isOnline ? Icons.wifi_rounded : Icons.wifi_off_rounded,
            size: 17,
          ),
          const SizedBox(width: 8),
          Text(
            isOnline ? 'You are online' : 'Offline mode',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const Spacer(),
          Text(
            isOnline ? 'Borrowing is available' : 'Your shelf is saved',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    ),
  );
}

class _Intro extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Find your next\nsmall obsession.',
        style: Theme.of(context).textTheme.displaySmall,
      ),
      const SizedBox(height: 12),
      Text(
        'A quiet place for books you want to carry with you.',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    ],
  );
}

class _BookCard extends StatelessWidget {
  const _BookCard({required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    final isAdded = context.select<ShelfBloc, bool>(
      (bloc) => bloc.state.any((item) => item.id == book.id),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(book.coverColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.category,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.4,
                  ),
                ),
                const Spacer(),
                Text(
                  book.title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 23,
                    height: 0.98,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  book.author,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 9),
        Row(
          children: [
            Expanded(
              child: Text(
                book.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              tooltip: isAdded ? 'Remove from shelf' : 'Add to shelf',
              onPressed: () => context.read<ShelfBloc>().add(
                isAdded ? ShelfBookRemoved(book) : ShelfBookAdded(book),
              ),
              icon: Icon(
                isAdded
                    ? Icons.check_circle_rounded
                    : Icons.add_circle_outline_rounded,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CheckoutBar extends StatelessWidget {
  const _CheckoutBar();

  @override
  Widget build(
    BuildContext context,
  ) => BlocBuilder<CheckoutBloc, CheckoutState>(
    builder: (context, state) => Container(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${state.itemCount} ${state.itemCount == 1 ? 'book' : 'books'} on your shelf',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 3),
                Text(
                  state.completed
                      ? 'Borrowed. Enjoy the beginning.'
                      : state.reason,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          FilledButton.icon(
            onPressed: state.canCheckout
                ? () => context.read<CheckoutBloc>().add(CheckoutRequested())
                : null,
            icon: state.isSubmitting
                ? const SizedBox.square(
                    dimension: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.arrow_forward_rounded),
            label: const Text('Borrow shelf'),
          ),
        ],
      ),
    ),
  );
}
