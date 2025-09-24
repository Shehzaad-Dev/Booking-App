import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ServiceOptionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? textColor;

  const ServiceOptionCard({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isSelected = false,
    this.backgroundColor,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color:
              backgroundColor ??
              (isSelected ? AppTheme.white : AppTheme.primaryBlue),
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
          border: isSelected
              ? Border.all(color: AppTheme.primaryBlue, width: 2)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color:
                  iconColor ??
                  (isSelected ? AppTheme.primaryBlue : AppTheme.white),
            ),
            const SizedBox(height: AppTheme.spacingS),
            Text(
              label,
              style: TextStyle(
                color:
                    textColor ??
                    (isSelected ? AppTheme.primaryBlue : AppTheme.white),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchInputField extends StatelessWidget {
  final String label;
  final IconData prefixIcon;
  final String? hintText;
  final TextEditingController? controller;
  final VoidCallback? onTap;
  final bool readOnly;

  const SearchInputField({
    super.key,
    required this.label,
    required this.prefixIcon,
    this.hintText,
    this.controller,
    this.onTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(prefixIcon, color: AppTheme.mediumGrey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
          borderSide: const BorderSide(color: AppTheme.borderGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
          borderSide: const BorderSide(color: AppTheme.borderGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
          borderSide: const BorderSide(color: AppTheme.primaryBlue, width: 2),
        ),
        filled: true,
        fillColor: AppTheme.lightGrey,
      ),
    );
  }
}

class PromoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback? onTap;

  const PromoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
    required this.textColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
          border: backgroundColor == AppTheme.white
              ? Border.all(color: AppTheme.primaryBlue, width: 1)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppTheme.spacingXS),
            Text(subtitle, style: TextStyle(color: textColor, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final String? actionText;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onTap,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            if (onTap != null && actionText != null)
              TextButton(onPressed: onTap, child: Text(actionText!)),
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: AppTheme.spacingXS),
          Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
        ],
        const SizedBox(height: AppTheme.spacingM),
      ],
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.white,
        selectedItemColor: AppTheme.primaryBlue,
        unselectedItemColor: AppTheme.mediumGrey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'My account',
          ),
        ],
      ),
    );
  }
}
