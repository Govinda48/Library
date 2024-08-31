import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AnimationConfiguration.staggeredList(
          position: 0,
          duration: Duration(seconds: 1),
          child: SlideAnimation(
            horizontalOffset: 50.0,
            child: FadeInAnimation(
              child: Text(
                'About Us',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.deepPurple,
        // actions: [
        //   IconButton(
        //     icon: const Icon(
        //       Icons.search,
        //       color: Colors.white,
        //     ),
        //     onPressed: () {
        //       // Add search action
        //     },
        //   ),
        //   IconButton(
        //     icon: const Icon(
        //       Icons.info,
        //       color: Colors.white,
        //     ),
        //     onPressed: () {
        //       // Navigator.push(
        //       //   context,
        //       //   MaterialPageRoute(
        //       //     builder: (context) => const AboutUsScreen(),
        //       //   ),
        //       // );
        //     },
        //   ),
        // ],
        elevation: 10.0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Image Section
            Stack(
              children: [
                // Background Image
                Container(
                  width: double.infinity,
                  height: 300,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/logo1.png',
                      ), // Use your image path here
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Positioned Information Box
                Positioned(
                  top: 200,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10.0,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Text(
                          'GET IN TOUCH!',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Grey Container Below the Image
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                // color: Colors.grey,
                width: double.infinity,
                height: 3000,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Civil: This category deals with non-criminal disputes, including property disputes, contracts, family law, and other civil matters. It encompasses the laws that regulate rights and obligations of individuals and organizations. \n\nCriminal: This category is related to laws that define criminal offenses and the legal procedures for addressing criminal behavior. It includes various crimes like theft, assault, fraud, and other offenses against society and individuals. \n\nFamily: This category covers laws related to family matters such as marriage, divorce, child custody, adoption, and inheritance. It is foc used on maintaining and regulating family relationships and resolving disputes within them. \n\nProperty: This category involves laws that govern the ownership and use of property, including real estate transactions, leases, and property disputes. It covers both movable and immovable property rights. \n\nNI Act (Negotiable Instruments Act): This category deals with laws regarding negotiable instruments like cheques, promissory notes, bills of exchange, etc. It is primarily focused on the legal framework for the functioning of these instruments and resolving disputes related to them. \n\nConstitution: This category involves the interpretation and application of the Constitution of the country. It covers fundamental rights, duties, government structure, and the legal framework that defines the relationship between the state and its citizens. \n\nJMFC (Judicial Magistrate First Class): This category is related to the JMFC exams and the legal procedures and knowledge required for candidates appearing for judicial exams. It covers subjects and topics relevant to judicial services. \n\nStudent: This category focuses on legal education for students, including study materials, notes, case laws, and guidelines to help law students understand and excel in their studies. \n\nBare Act: This category contains the verbatim text of the legal acts passed by the legislature. It provides the exact wording of the law as it is officially published, without any interpretation or commentary. \n\nOther: This category encompasses other miscellaneous legal topics that do not fit into the above categories. It could include emerging legal issues, niche areas of law, or specialized topics.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build category items with their descriptions
  // ignore: unused_element
  Widget _buildCategoryItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            description,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
