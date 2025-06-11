import 'package:flutter/material.dart';
import 'package:lung_life/views/nutrition/SupplementDetailScreen.dart';

class Supplement {
  final String name;
  final String description;
  final String imagePath;
  final String suitableFor;

  Supplement({required this.name, required this.description, required this.imagePath, required this.suitableFor});
}

class SupplementsScreen extends StatelessWidget {
  final List<Supplement> supplements = [
    Supplement(name: "Whey Protein Concentrate", description: "A common and cost-effective form of whey protein, typically containing 70-80% protein by weight with some lactose and fat. Great for muscle growth and recovery.", imagePath: 'assets/images/concentrate.png', suitableFor: "Athletes and active individuals"),
    Supplement(name: "Whey Protein Isolate", description: "A purer form of whey protein, containing 90% or more protein. It has less lactose and fat, making it ideal for those sensitive to dairy or on stricter diets.", imagePath: 'assets/images/isolate.png', suitableFor: "Lactose-sensitive individuals and those on low-carb diets"),
    Supplement(name: "Hydrolyzed Whey Protein", description: "This protein has undergone a process called hydrolysis, breaking down proteins into smaller peptides for faster absorption and easier digestion. Excellent for post-workout recovery.", imagePath: 'assets/images/hydrolyzed.png', suitableFor: "Post-workout recovery, easy digestion for sensitive stomachs"),
    Supplement(name: "Casein Protein", description: "A slow-digesting protein derived from milk, providing a sustained release of amino acids into the bloodstream. Ideal for consumption before bed to aid muscle recovery overnight.", imagePath: 'assets/images/casein.png', suitableFor: "Nighttime protein intake for muscle recovery"),
    Supplement(name: "Vegan Protein Blend", description: "A plant-based protein alternative for vegans, vegetarians, or those with dairy allergies. Often a mix of pea, rice, and hemp proteins to provide a complete amino acid profile.", imagePath: 'assets/images/Vegan.jpg', suitableFor: "Vegans, vegetarians, and those with dairy allergies"),
    Supplement(name: "Mass Gainer", description: "Designed for individuals looking to significantly increase muscle mass and body weight. It's high in calories, carbohydrates, and protein to support intense training and recovery.", imagePath: 'assets/images/mass gainer.png', suitableFor: "Individuals looking to gain weight and muscle mass"),
    Supplement(name: "Whey Protein for Women", description: "Formulated with women's specific nutritional needs in mind, often including added vitamins, minerals, and ingredients for hormonal balance or weight management support.", imagePath: 'assets/images/concentrate.png', suitableFor: "Women seeking protein supplementation for fitness and health"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1C1B29),
      appBar: AppBar(
        backgroundColor: Color(0xFF1C1B29),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Supplements",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: supplements.length,
        itemBuilder: (context, index) {
          final supplement = supplements[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SupplementDetailScreen(supplement: supplement),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: Color(0xFF2C2B3A),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Color(0xFF3B3A4C),
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: AssetImage(supplement.imagePath),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            supplement.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            supplement.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
} 