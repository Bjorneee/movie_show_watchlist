import 'package:flutter/material.dart';

class PosterCard extends StatelessWidget {
  final String title;
  final double height;
  final double width;

  const PosterCard({
    super.key,
    required this.title,
    this.height = 260,
    this.width = 180,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge,
        ),
      ),
    );
  }
}

class DetailFieldBox extends StatelessWidget {
  final String label;
  final Widget child;

  const DetailFieldBox({
    super.key,
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }
}

class FilledDisplayBox extends StatelessWidget {
  final String text;

  const FilledDisplayBox({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(text),
    );
  }
}

class PrimaryActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const PrimaryActionButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}

class DangerActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const DangerActionButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.error,
        foregroundColor: Theme.of(context).colorScheme.onError,
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}