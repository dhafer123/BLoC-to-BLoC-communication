import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
            const SliverToBoxAdapter(child: _Header()),
            SliverToBoxAdapter(child: _StatusStrip()),
            SliverAppBar.large(
              pinned: true,
              expandedHeight: 124,
              title: const Text('Find your next\nsmall obsession.'),
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 68, 24, 12),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'A quiet place for books you want to carry with you.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: _ShelfSummary()),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
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
          ],
        ),
      ),
      bottomNavigationBar: const SafeArea(top: false, child: _CheckoutBar()),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

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
                BlocBuilder<ShelfBloc, List<Book>>(
                  builder: (context, shelf) => Badge(
                    isLabelVisible: shelf.isNotEmpty,
                    label: Text('${shelf.length}'),
                    child: IconButton(
                      tooltip: 'Your shelf',
                      onPressed: () {},
                      icon: const Icon(Icons.bookmark_border_rounded),
                    ),
                  ),
                ),
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
    builder: (context, isOnline) {
      final statusColor = isOnline
          ? const Color(0xFF1B4A3B)
          : const Color(0xFF7A3026);
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isOnline ? const Color(0xFFDCEFE4) : const Color(0xFFF7D7CE),
          borderRadius: BorderRadius.circular(10),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          child: Row(
            key: ValueKey(isOnline),
            children: [
              Icon(
                isOnline ? Icons.wifi_rounded : Icons.wifi_off_rounded,
                color: statusColor,
                size: 17,
              ),
              const SizedBox(width: 8),
              Text(
                isOnline ? 'You are online' : 'Offline mode',
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                isOnline ? 'Borrowing is available' : 'Your shelf is saved',
                style: TextStyle(color: statusColor, fontSize: 14),
              ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 400.ms);
    },
  );
}

class _ShelfSummary extends StatelessWidget {
  const _ShelfSummary();

  @override
  Widget build(
    BuildContext context,
  ) => BlocBuilder<CheckoutBloc, CheckoutState>(
    builder: (context, state) => Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                state.itemCount == 0
                    ? Icons.menu_book_outlined
                    : Icons.bookmark_added_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
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
    final coverColor = Color(book.coverColor);
    final coverInk =
        ThemeData.estimateBrightnessForColor(coverColor) == Brightness.light
        ? const Color(0xFF172121)
        : Colors.white;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: coverColor,
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
                      ).copyWith(color: coverInk),
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
                      ).copyWith(color: coverInk),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      book.author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13, color: coverInk),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 8,
                bottom: 8,
                child: IconButton.filled(
                  tooltip: isAdded ? 'Remove from shelf' : 'Add to shelf',
                  onPressed: () => context.read<ShelfBloc>().add(
                    isAdded ? ShelfBookRemoved(book) : ShelfBookAdded(book),
                  ),
                  icon: Icon(isAdded ? Icons.check_rounded : Icons.add_rounded)
                      .animate(target: isAdded ? 1 : 0)
                      .scale(
                        begin: const Offset(1, 1),
                        end: const Offset(1.2, 1.2),
                        duration: 150.ms,
                      ),
                ),
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(duration: 450.ms).slideY(begin: 0.04, end: 0);
  }
}

class _CheckoutBar extends StatelessWidget {
  const _CheckoutBar();

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<CheckoutBloc, CheckoutState>(
        builder: (context, state) => AnimatedOpacity(
          duration: const Duration(milliseconds: 250),
          opacity: state.canCheckout ? 1 : 0.4,
          child: IgnorePointer(
            ignoring: !state.canCheckout,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 14, 24, 18),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
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
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: () =>
                        context.read<CheckoutBloc>().add(CheckoutRequested()),
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
          ),
        ),
      );
}
