import 'package:flutter/material.dart';
import 'package:KafeKotaKita/Constant/colors.dart';
import 'package:KafeKotaKita/Constant/textstyle.dart';

class CustomCardCafe extends StatelessWidget {
  final String cafeimgurl;
  final String namacafe;
  final String lokasi;
  final String jambuka;
  final String jamtutup;
  final double rating;
  final bool isOpen;
  final VoidCallback? onTap;

  const CustomCardCafe({
    super.key,
    required this.cafeimgurl,
    required this.namacafe,
    required this.lokasi,
    required this.jambuka,
    required this.jamtutup,
    required this.rating,
    this.isOpen = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color statusColor = isOpen ? Colors.green.shade600 : Colors.red.shade600;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: clrbg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Image Section
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  image: DecorationImage(
                    image: NetworkImage(cafeimgurl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: clrfont2,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            SizedBox(width: 4),
                            Text(
                              rating.toString(),
                              style: TextStyle(
                                color: white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),

            // Info Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      namacafe,
                      style: AppTextStyles.poppinsBody(
                        weight: AppTextStyles.semiBold,
                        fontSize: 14,
                        color: primaryc,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Text(
                      lokasi,
                      style: AppTextStyles.interBody(
                        weight: AppTextStyles.regular,
                        color: primaryc,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 12),

                    // Status + Jam Operasional (Wrap)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            isOpen ? 'Buka' : 'Tutup',
                            style: AppTextStyles.interBody(
                              color: white,
                              fontSize: 12,
                              weight: AppTextStyles.medium,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: primaryc,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.access_time, color: white, size: 12),
                              SizedBox(width: 4),
                              Text(
                                jambuka+'-'+jamtutup,
                                style: AppTextStyles.interBody(
                                  color: white,
                                  fontSize: 12,
                                  weight: AppTextStyles.medium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
