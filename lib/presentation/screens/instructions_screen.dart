import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InstructionsScreen extends StatelessWidget {
  const InstructionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'التعليمات',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade50, Colors.lightBlue.shade50],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: Colors.blue.shade200, width: 1),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    size: 48.sp,
                    color: Colors.blue.shade700,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'البديل المنزلي للأدوات',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'يمكنك استخدام هذه البدائل المنزلية بدلاً من الأدوات المتخصصة',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.blue.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // Equipment alternatives
            ..._buildEquipmentAlternatives(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildEquipmentAlternatives() {
    final alternatives = [
      {
        'title': 'وزن نصف كيلو / كيلو ونصف',
        'alternative': 'قنينة ماء',
        'icon': Icons.water_drop,
        'color': Colors.blue,
      },
      {
        'title': 'الكرة الإسفنجية',
        'alternative': 'إسفنجة مطبخ',
        'icon': Icons.circle,
        'color': Colors.orange,
      },
      {
        'title': 'سوار مطاطي لكل زوج',
        'alternative': 'مطاط نقود',
        'icon': Icons.circle_outlined,
        'color': Colors.green,
      },
      {
        'title': 'قطعة إسفنجية للف',
        'alternative': 'قطعة قماش',
        'icon': Icons.rectangle,
        'color': Colors.purple,
      },
      {
        'title': 'الراكيت + وزن',
        'alternative':
            'مقلاة صغيرة أو ملعقة خشب ثقيلة يمكن الإمساك بها وضرب كرة إسفنجية بها',
        'icon': Icons.sports_tennis,
        'color': Colors.red,
      },
      {
        'title': 'الشيك شاك أو لاصق ڤيلكرو',
        'alternative':
            'استخدام شرائط ڤيلكرو مأخوذة من أحذية قديمة أو شنطة، تُقص وتُثبت على الطاولة في المنزل',
        'icon': Icons.attach_file,
        'color': Colors.teal,
      },
      {
        'title': 'شريط المقاومة أو الشريط المطاطي',
        'alternative':
            'رباط بنطال رياضي قديم أو رباط شنطة سفر أو مطاط نقود كبير (أو 2 مربوطين) يُوصلوا ببعض',
        'icon': Icons.fitness_center,
        'color': Colors.indigo,
      },
    ];

    return alternatives.map((item) => _buildAlternativeCard(item)).toList();
  }

  Widget _buildAlternativeCard(Map<String, dynamic> item) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: item['color'].withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Container(
              width: 60.w,
              height: 60.h,
              decoration: BoxDecoration(
                color: item['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                item['icon'],
                color: item['color'],
                size: 28.sp,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'],
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 12.sp,
                        color: item['color'],
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          item['alternative'],
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey.shade600,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
