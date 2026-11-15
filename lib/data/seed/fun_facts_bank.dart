/// "Did You Know?" daily Bible fun facts extracted from sword drill™ (`App-AlODYBux.js`).
class FunFactsBank {
  FunFactsBank._();

  static const List<String> facts = [
    'The Bible was written over roughly 1,500 years by more than 40 different human authors across three continents (Asia, Africa, and Europe).',
    'Psalm 119 is the longest chapter in the Bible with 176 verses — and it is an acrostic poem structured around the 22 letters of the Hebrew alphabet.',
    'Psalm 117 is the shortest chapter in the Bible, containing just two verses that call all nations to praise the Lord.',
    'The Book of Esther and Song of Songs are the only two books in the Bible that do not explicitly mention the word "God" or "Lord".',
    'The word "Christian" appears only three times in the entire New Testament: Acts 11:26, Acts 26:28, and 1 Peter 4:16.',
    'Luke, a Gentile physician, wrote more of the New Testament by word count than any other author — including the Apostle Paul — when combining Luke and Acts.',
    'Methuselah is the oldest person recorded in the Bible, living to be 969 years old (Genesis 5:27), and died the same year the Flood began.',
    'The Bible was originally written in three languages: Hebrew, Aramaic, and Koine Greek.',
    'In the Gospel of John, Jesus performs seven specific "signs" (miracles) before His resurrection to point to His identity as the Messiah.',
    'The shortest verse in the English Bible is "Jesus wept" (John 11:35), though in the original Greek, 1 Thessalonians 5:16 ("Rejoice always") is even shorter by letter count.',
    'King Solomon wrote 3,000 proverbs and 1,005 songs (1 Kings 4:32), and sovereigns from across the ancient world traveled to Jerusalem to hear his wisdom.',
    'The Book of Isaiah has 66 chapters — matching the 66 books of the Protestant canon (39 in the first section like the OT, and 27 in the second section like the NT).',
    'Wait on the Lord! The phrase "Do not be afraid" or "Fear not" appears more than 300 times across the Old and New Testaments.',
    'Paul wrote several of his most joyful New Testament letters — Philippians, Ephesians, Colossians, and Philemon — while under house arrest in Rome.',
    'In Hebrew, the name "Bethlehem" (Beit Lechem) literally means "House of Bread" — the birthplace of Jesus, who called Himself the Bread of Life.',
    'The prophet Jeremiah wept so deeply over Jerusalem\'s unfaithfulness that he became known as the "Weeping Prophet" and authored Lamentations.',
    'Before being renamed Paul, Saul of Tarsus was a tentmaker by trade and worked alongside Priscilla and Aquila in Corinth (Acts 18:3).',
    'Only two people in the Old Testament never experienced physical death: Enoch (Genesis 5:24) and the prophet Elijah (2 Kings 2:11).',
    'The Dead Sea Scrolls, discovered in caves at Qumran starting in 1947, contained fragments of every Old Testament book except Esther, confirming the remarkable preservation of Scripture.',
    'Hebrews 4:12 inspired the name "Sword Drill" — describing God\'s Word as living, effective, and sharper than any double-edged sword!',
  ];

  static String getFactOfTheDay([DateTime? date]) {
    final now = date ?? DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    return facts[dayOfYear % facts.length];
  }
}
