import 'package:flutter/material.dart';
import 'package:wasslni_plus/generated/l10n.dart';
import 'package:wasslni_plus/app_styles.dart';
import 'package:wasslni_plus/models/faq_model.dart';
import 'package:wasslni_plus/services/faq_service.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({super.key});

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  final _faqService = FAQService();
  final _searchController = TextEditingController();
  String _selectedCategory = 'all';
  List<FAQ> _displayedFAQs = [];
  Map<String, bool> _expandedStates = {};

  @override
  void initState() {
    super.initState();
    _loadFAQs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadFAQs() {
    setState(() {
      if (_selectedCategory == 'all') {
        _displayedFAQs = _faqService.getAllFAQs();
      } else {
        _displayedFAQs = _faqService.getFAQsByCategory(_selectedCategory);
      }
    });
  }

  void _searchFAQs(String query) {
    final languageCode = Localizations.localeOf(context).languageCode;
    setState(() {
      if (query.isEmpty) {
        _loadFAQs();
      } else {
        _displayedFAQs = _faqService.searchFAQs(query, languageCode);
      }
    });
  }

  void _toggleExpanded(String id) {
    setState(() {
      _expandedStates[id] = !(_expandedStates[id] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tr = S.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.faq),
        backgroundColor: AppStyles.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: TextField(
              controller: _searchController,
              onChanged: _searchFAQs,
              decoration: InputDecoration(
                hintText: tr.search_faq,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _searchFAQs('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Category filter
          if (_searchController.text.isEmpty)
            Container(
              height: 50,
              color: Colors.grey[50],
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: [
                  _CategoryChip(
                    label: tr.all,
                    isSelected: _selectedCategory == 'all',
                    onTap: () {
                      setState(() {
                        _selectedCategory = 'all';
                        _loadFAQs();
                      });
                    },
                  ),
                  _CategoryChip(
                    label: FAQCategory.general.getName(languageCode),
                    isSelected: _selectedCategory == 'general',
                    onTap: () {
                      setState(() {
                        _selectedCategory = 'general';
                        _loadFAQs();
                      });
                    },
                  ),
                  _CategoryChip(
                    label: FAQCategory.orders.getName(languageCode),
                    isSelected: _selectedCategory == 'orders',
                    onTap: () {
                      setState(() {
                        _selectedCategory = 'orders';
                        _loadFAQs();
                      });
                    },
                  ),
                  _CategoryChip(
                    label: FAQCategory.delivery.getName(languageCode),
                    isSelected: _selectedCategory == 'delivery',
                    onTap: () {
                      setState(() {
                        _selectedCategory = 'delivery';
                        _loadFAQs();
                      });
                    },
                  ),
                  _CategoryChip(
                    label: FAQCategory.payment.getName(languageCode),
                    isSelected: _selectedCategory == 'payment',
                    onTap: () {
                      setState(() {
                        _selectedCategory = 'payment';
                        _loadFAQs();
                      });
                    },
                  ),
                  _CategoryChip(
                    label: FAQCategory.account.getName(languageCode),
                    isSelected: _selectedCategory == 'account',
                    onTap: () {
                      setState(() {
                        _selectedCategory = 'account';
                        _loadFAQs();
                      });
                    },
                  ),
                ],
              ),
            ),

          // FAQ List
          Expanded(
            child: _displayedFAQs.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.help_outline,
                            size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          tr.no_faq_found,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          tr.try_different_search,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _displayedFAQs.length,
                    itemBuilder: (context, index) {
                      final faq = _displayedFAQs[index];
                      final isExpanded = _expandedStates[faq.id] ?? false;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          onTap: () => _toggleExpanded(faq.id),
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      isExpanded
                                          ? Icons.remove_circle_outline
                                          : Icons.add_circle_outline,
                                      color: AppStyles.primaryColor,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        faq.getQuestion(languageCode),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (isExpanded) ...[
                                  const SizedBox(height: 12),
                                  const Divider(),
                                  const SizedBox(height: 12),
                                  Text(
                                    faq.getAnswer(languageCode),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Still have questions section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppStyles.primaryColor.withValues(alpha: 0.1),
              border: Border(
                top: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: Column(
              children: [
                Text(
                  tr.still_have_questions,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  tr.contact_support_team,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/contact-support');
                  },
                  icon: const Icon(Icons.support_agent),
                  label: Text(tr.contact_support),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyles.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
        selectedColor: AppStyles.primaryColor,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        backgroundColor: Colors.grey[200],
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}
