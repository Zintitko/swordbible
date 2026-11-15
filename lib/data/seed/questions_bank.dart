import '../models/models.dart';

/// Comprehensive Bible Trivia Question Bank for sword drill™ (CSB).
/// Includes questions across Levels 1, 2, 3, Family Mode sublevels (`1a`, `1b`),
/// Old & New Testaments, Topics, Characters, and Books, with full "Sharpen Your Sword"
/// Scripture context, CSB verse quotes, and theological takeaways.
class QuestionsBank {
  QuestionsBank._();

  static const List<String> topics = [
    'Miracles',
    'Parables',
    "Jesus' Life on Earth",
    'Israel',
    'Wisdom',
    'Prophecy',
    'Commands & Laws',
    'Geography',
    'Character of God',
  ];

  static const List<String> characters = [
    'Jesus',
    'Moses',
    'David',
    'Paul',
    'Peter',
    'Abraham',
    'Solomon',
    'Elijah',
    'Ruth',
    'Esther',
    'Daniel',
    'Joseph',
    'Joshua',
  ];

  static const List<String> oldTestamentBooks = [
    'Genesis',
    'Exodus',
    'Leviticus',
    'Numbers',
    'Deuteronomy',
    'Joshua',
    'Judges',
    'Ruth',
    '1 Samuel',
    '2 Samuel',
    '1 Kings',
    '2 Kings',
    'Esther',
    'Job',
    'Psalms',
    'Proverbs',
    'Isaiah',
    'Jeremiah',
    'Daniel',
    'Jonah',
  ];

  static const List<String> newTestamentBooks = [
    'Matthew',
    'Mark',
    'Luke',
    'John',
    'Acts',
    'Romans',
    '1 Corinthians',
    'Galatians',
    'Ephesians',
    'Philippians',
    'Hebrews',
    'James',
    '1 Peter',
    'Revelation',
  ];

  static const List<BibleQuestion> allQuestions = [
    // --- OFFICIAL PLACEMENT / SAMPLE PLAY QUESTIONS (from SamplePlayPage-7L10Ljeb.js) ---
    BibleQuestion(
      id: 'q_sample_1',
      questionText: 'What did God create on the very first day of creation in Genesis 1?',
      options: ['Land and seas', 'Light', 'Sun, moon, and stars', 'Living creatures'],
      correctOptionIndex: 1,
      difficulty: 1,
      sublevel: '1a',
      testament: 'OT',
      book: 'Genesis',
      topic: 'Character of God',
      bibleReference: 'Genesis 1:3–5 (CSB)',
      csbVerseText:
          'Then God said, "Let there be light," and there was light. God saw that the light was good, and God separated the light from the darkness.',
      contextExplainer:
          'In Genesis 1, God brings order out of formlessness and darkness simply by speaking. Light is created on Day 1, while the sun, moon, and stars are appointed on Day 4.',
      whyThisMatters:
          'Scripture begins by showing that God Himself is the ultimate source of light and life — before the sun ever shone, God\'s word brought light into the darkness (see also John 1:4–5).',
    ),
    BibleQuestion(
      id: 'q_sample_2',
      questionText: 'With what weapon did young David defeat the Philistine giant Goliath?',
      options: ['King Saul\'s bronze sword', 'A sling and a smooth stone', 'An iron spear', 'A bow and arrow'],
      correctOptionIndex: 1,
      difficulty: 1,
      sublevel: '1a',
      testament: 'OT',
      book: '1 Samuel',
      topic: 'Israel',
      character: 'David',
      bibleReference: '1 Samuel 17:49–50 (CSB)',
      csbVerseText:
          'David put his hand in the bag, took out a stone, slung it, and hit the Philistine on his forehead. The stone sank into his forehead, and he fell facedown on the ground.',
      contextExplainer:
          'When Israel\'s army cowered for 40 days before Goliath of Gath, David refused Saul\'s heavy armor and met the giant with a shepherd\'s sling, five smooth stones from the wadi, and unshakeable confidence in the Lord of Armies.',
      whyThisMatters:
          'As David declared in 1 Samuel 17:47, "The Lord does not save by sword or by spear; for the battle is the Lord\'s." God delights in using humble faith to overturn human pride.',
    ),
    BibleQuestion(
      id: 'q_sample_3',
      questionText: 'In what town was Jesus born, fulfilling the prophecy of Micah 5:2?',
      options: ['Nazareth', 'Bethlehem', 'Capernaum', 'Jericho'],
      correctOptionIndex: 1,
      difficulty: 1,
      sublevel: '1a',
      testament: 'NT',
      book: 'Luke',
      topic: "Jesus' Life on Earth",
      character: 'Jesus',
      bibleReference: 'Luke 2:4–7; Micah 5:2 (CSB)',
      csbVerseText:
          'Joseph also went up from the town of Nazareth in Galilee, to Judea, to the city of David, which is called Bethlehem, because he was of the house and family line of David.',
      contextExplainer:
          'Though Mary and Joseph lived in Nazareth, Caesar Augustus\'s census brought them to Bethlehem ("House of Bread"), the ancestral hometown of King David, just as the prophet Micah foretold 700 years earlier.',
      whyThisMatters:
          'God sovereignly guided even the decree of a Roman emperor to fulfill His centuries-old promise about where the Messiah King would enter the world.',
    ),
    BibleQuestion(
      id: 'q_sample_4',
      questionText: 'Which parable did Jesus tell in answer to the lawyer\'s question, "And who is my neighbor?"',
      options: [
        'The Prodigal Son',
        'The Good Samaritan',
        'The Rich Fool',
        'The Unforgiving Servant',
      ],
      correctOptionIndex: 1,
      difficulty: 2,
      sublevel: '1b',
      testament: 'NT',
      book: 'Luke',
      topic: 'Parables',
      character: 'Jesus',
      bibleReference: 'Luke 10:29–37 (CSB)',
      csbVerseText:
          '"Which of these three do you think proved to be a neighbor to the man who fell into the hands of the robbers?" "The one who showed mercy to him," he said. Then Jesus told him, "Go and do the same."',
      contextExplainer:
          'A legal expert tried to justify himself by narrowing the definition of "neighbor." Jesus responded with a story where a priest and a Levite passed by a wounded traveler, while a Samaritan — despised by Jews — stopped and paid for his care.',
      whyThisMatters:
          'Jesus shifts the question from "Who qualifies for my love?" to "Whose neighbor can I be through costly mercy?" Neighbor-love crosses every social and cultural boundary.',
    ),
    BibleQuestion(
      id: 'q_sample_5',
      questionText: 'On which mountain did Elijah challenge the 450 prophets of Baal to call down fire from heaven?',
      options: ['Mount Sinai', 'Mount Carmel', 'Mount Hermon', 'Mount Nebo'],
      correctOptionIndex: 1,
      difficulty: 2,
      sublevel: '1b',
      testament: 'OT',
      book: '1 Kings',
      topic: 'Miracles',
      character: 'Elijah',
      bibleReference: '1 Kings 18:19–39 (CSB)',
      csbVerseText:
          'Then the Lord\'s fire fell and consumed the burnt offering, the wood, the stones, and the dust, and it licked up the water that was in the trench. When all the people saw it, they fell facedown and said, "The Lord, he is God! The Lord, he is God!"',
      contextExplainer:
          'During King Ahab\'s reign and a three-year drought, Elijah soaked the altar of the Lord on Mount Carmel with twelve jars of water before praying a simple prayer. Fire fell immediately from the Lord.',
      whyThisMatters:
          'Elijah called wavering Israel out of spiritual double-mindedness ("How long will you hesitate between two opinions?"), demonstrating that Yahweh alone is the living God who hears and answers.',
    ),
    BibleQuestion(
      id: 'q_sample_6',
      questionText: 'Which Roman governor heard Paul\'s defense in Acts 26 and replied, "In a short time you will persuade me to become a Christian"?',
      options: ['Pontius Pilate', 'Felix', 'King Agrippa II', 'Gallio'],
      correctOptionIndex: 2,
      difficulty: 3,
      testament: 'NT',
      book: 'Acts',
      topic: 'Prophecy',
      character: 'Paul',
      bibleReference: 'Acts 26:27–29 (CSB)',
      csbVerseText:
          '"King Agrippa, do you believe the prophets? I know that you believe." Agrippa said to Paul, "Are you going to persuade me to become a Christian so easily?"',
      contextExplainer:
          'While imprisoned in Caesarea before being sent to Rome, Paul testified before Governor Festus and King Herod Agrippa II, appealing directly to Agrippa\'s knowledge of the Hebrew prophets.',
      whyThisMatters:
          'Even in chains, Paul viewed royal courtrooms not as setbacks, but as pulpits to bear witness to the risen Christ before kings (fulfilling Acts 9:15).',
    ),

    // --- MORE LEVEL 1 (NEW TO THE STORY & FAMILY MODE 1a/1b) ---
    BibleQuestion(
      id: 'q_l1_noah',
      questionText: 'What bird did Noah send out from the ark that returned with a freshly plucked olive leaf?',
      options: ['A raven', 'A dove', 'An eagle', 'A sparrow'],
      correctOptionIndex: 1,
      difficulty: 1,
      sublevel: '1a',
      testament: 'OT',
      book: 'Genesis',
      topic: 'Character of God',
      bibleReference: 'Genesis 8:10–11 (CSB)',
      csbVerseText:
          'So he waited seven more days and sent out the dove from the ark again. The dove came to him at evening, and there in its beak was a freshly plucked olive leaf! So Noah knew that the water on the earth had subsided.',
      contextExplainer:
          'After the floodwaters covered the earth, Noah sent out a raven and then a dove. On its second flight, the dove brought back an olive leaf — a sign that new life was sprouting on dry ground.',
      whyThisMatters:
          'God remembered Noah in the ark and brought renewal after judgment, sealing His covenant with the rainbow.',
    ),
    BibleQuestion(
      id: 'q_l1_moses_sea',
      questionText: 'Which body of water did God part so Moses and the Israelites could escape Pharaoh\'s army on dry ground?',
      options: ['The Dead Sea', 'The Red Sea', 'The Sea of Galilee', 'The Mediterranean Sea'],
      correctOptionIndex: 1,
      difficulty: 1,
      sublevel: '1a',
      testament: 'OT',
      book: 'Exodus',
      topic: 'Miracles',
      character: 'Moses',
      bibleReference: 'Exodus 14:21–22 (CSB)',
      csbVerseText:
          'Then Moses stretched out his hand over the sea. The Lord drove the sea back by a strong east wind all that night and turned the sea into dry land. So the waters were divided, and the Israelites went through the sea on dry ground.',
      contextExplainer:
          'Trapped between Pharaoh\'s chariots and the sea, Israel cried out in fear. Moses told them, "Stand firm and see the Lord\'s salvation," and God opened a highway through the waters.',
      whyThisMatters:
          'The Red Sea deliverance is the defining salvation event of the Old Testament, pointing forward to how Christ rescues us from bondage to sin.',
    ),
    BibleQuestion(
      id: 'q_l1_daniel_lions',
      questionText: 'Why was Daniel thrown into the lions\' den during the reign of King Darius?',
      options: [
        'He refused to interpret the king\'s dream',
        'He continued praying to God three times a day despite a royal decree',
        'He knocked down a golden statue',
        'He refused to eat meat from the king\'s table',
      ],
      correctOptionIndex: 1,
      difficulty: 1,
      sublevel: '1a',
      testament: 'OT',
      book: 'Daniel',
      topic: 'Miracles',
      character: 'Daniel',
      bibleReference: 'Daniel 6:10, 22 (CSB)',
      csbVerseText:
          'When Daniel learned that the document had been signed, he went into his house. The windows in its upper room opened toward Jerusalem, and three times a day he got down on his knees, prayed, and gave thanks to his God, just as he had done before.',
      contextExplainer:
          'Jealous officials tricked King Darius into signing a 30-day ban on praying to anyone except the king. Daniel kept his lifelong habit of prayer, and God sent His angel to shut the lions\' mouths.',
      whyThisMatters:
          'Faithfulness in crisis flows from faithfulness in daily habits. Daniel didn\'t start praying when trouble arrived — he simply kept praying "just as he had done before."',
    ),
    BibleQuestion(
      id: 'q_l1_jonah',
      questionText: 'To which city did God command the prophet Jonah to go and preach before Jonah fled on a ship to Tarshish?',
      options: ['Babylon', 'Nineveh', 'Damascus', 'Tyre'],
      correctOptionIndex: 1,
      difficulty: 1,
      sublevel: '1a',
      testament: 'OT',
      book: 'Jonah',
      topic: 'Prophecy',
      bibleReference: 'Jonah 1:1–3 (CSB)',
      csbVerseText:
          'The word of the Lord came to Jonah son of Amittai: "Get up! Go to the great city of Nineveh and preach against it because their evil has come up before me." Jonah got up to flee to Tarshish from the Lord\'s presence.',
      contextExplainer:
          'Nineveh was the capital of Assyria, Israel\'s fierce enemy. Jonah ran the opposite direction because he knew God was gracious and compassionate and might spare the Ninevites if they repented (Jonah 4:2).',
      whyThisMatters:
          'The Book of Jonah reveals that God\'s compassion extends even to Israel\'s enemies — and exposes how easily our own hearts can resent God\'s mercy toward outsiders.',
    ),
    BibleQuestion(
      id: 'q_l1_feeding_5000',
      questionText: 'What did a young boy share that Jesus multiplied to feed more than 5,000 people?',
      options: [
        'Seven loaves and a jar of oil',
        'Five barley loaves and two fish',
        'Three loaves and a basket of figs',
        'Unleavened bread and honey',
      ],
      correctOptionIndex: 1,
      difficulty: 1,
      sublevel: '1a',
      testament: 'NT',
      book: 'John',
      topic: 'Miracles',
      character: 'Jesus',
      bibleReference: 'John 6:9–11 (CSB)',
      csbVerseText:
          '"There\'s a boy here who has five barley loaves and two fish—but what are they for so many?" Jesus took the loaves, and after giving thanks, he distributed them to those who were seated—so also with the fish, as much as they wanted.',
      contextExplainer:
          'The feeding of the 5,000 is the only miracle (besides the resurrection) recorded in all four Gospels. Everyone ate until satisfied, and the disciples gathered twelve baskets of leftover pieces.',
      whyThisMatters:
          'In Jesus\' hands, a small offering becomes an abundant feast. The next day, Jesus declared, "I am the bread of life" (John 6:35).',
    ),
    BibleQuestion(
      id: 'q_l1_prodigal',
      questionText: 'In Jesus\' Parable of the Lost (Prodigal) Son, what did the father do while his younger son was still a long way off?',
      options: [
        'Sent a servant to question him first',
        'Waited inside the house for an apology',
        'Filled with compassion, he ran, threw his arms around him, and kissed him',
        'Required him to work in the fields for seven days',
      ],
      correctOptionIndex: 2,
      difficulty: 1,
      sublevel: '1a',
      testament: 'NT',
      book: 'Luke',
      topic: 'Parables',
      character: 'Jesus',
      bibleReference: 'Luke 15:20 (CSB)',
      csbVerseText:
          'So he got up and went to his father. But while the son was still a long way off, his father saw him and was filled with compassion. He ran, threw his arms around his neck, and kissed him.',
      contextExplainer:
          'In the ancient Near East, dignified patriarchs never hiked up their robes to run in public. Yet this father ran to absorb the shame and welcome his repentant son home with a robe, ring, sandals, and feast.',
      whyThisMatters:
          'This parable paints the clearest portrait in Scripture of the Father\'s eager, lavish grace toward both rebellious sinners and self-righteous older brothers.',
    ),
    BibleQuestion(
      id: 'q_l1_peter_water',
      questionText: 'Which disciple stepped out of the boat and walked on the water toward Jesus on the Sea of Galilee?',
      options: ['John', 'Peter', 'James', 'Andrew'],
      correctOptionIndex: 1,
      difficulty: 1,
      sublevel: '1a',
      testament: 'NT',
      book: 'Matthew',
      topic: 'Miracles',
      character: 'Peter',
      bibleReference: 'Matthew 14:28–31 (CSB)',
      csbVerseText:
          '"Lord, if it\'s you," Peter answered him, "command me to come to you on the water." He said, "Come." And climbing out of the boat, Peter started walking on the water and came toward Jesus.',
      contextExplainer:
          'During the fourth watch of the night, Jesus came walking on the stormy lake. Peter walked on the water while looking at Jesus, began to sink when he saw the strength of the wind, and cried, "Lord, save me!" — and Jesus immediately reached out and caught him.',
      whyThisMatters:
          'Even when our faith falters mid-storm, a three-word cry ("Lord, save me!") is met immediately by the outstretched hand of Jesus.',
    ),
    BibleQuestion(
      id: 'q_l1_ten_commandments',
      questionText: 'On which mountain did God give Moses the stone tablets containing the Ten Commandments?',
      options: ['Mount Zion', 'Mount Sinai', 'Mount Ararat', 'Mount Olivet'],
      correctOptionIndex: 1,
      difficulty: 1,
      sublevel: '1a',
      testament: 'OT',
      book: 'Exodus',
      topic: 'Commands & Laws',
      character: 'Moses',
      bibleReference: 'Exodus 19:20; 20:1–17 (CSB)',
      csbVerseText:
          'The Lord came down onto Mount Sinai, to the top of the mountain, and the Lord summoned Moses to the top of the mountain. So Moses went up.',
      contextExplainer:
          'After rescuing Israel from Egypt first by grace, God met His people at Mount Sinai (also called Horeb) and gave them the Ten Commandments to show how a redeemed covenant people should love God and neighbor.',
      whyThisMatters:
          'Notice the biblical order in Exodus 20:2: God rescues Israel *before* giving the Law. Obedience in Scripture is always a grateful response to grace, never a ladder to earn it.',
    ),
    BibleQuestion(
      id: 'q_l1_joseph_coat',
      questionText: 'What special gift did Jacob (Israel) give his favored son Joseph that stirred up his brothers\' jealousy?',
      options: [
        'A golden signet ring',
        'A long, ornate tunic (coat of many colors)',
        'A double flock of sheep',
        'A silver staff',
      ],
      correctOptionIndex: 1,
      difficulty: 1,
      sublevel: '1a',
      testament: 'OT',
      book: 'Genesis',
      topic: 'Israel',
      character: 'Joseph',
      bibleReference: 'Genesis 37:3–4 (CSB)',
      csbVerseText:
          'Now Israel loved Joseph more than his other sons because Joseph was a son born to him in his old age, and he made a long-sleeved robe for him. When his brothers saw that their father loved him more than all his brothers, they hated him.',
      contextExplainer:
          'Joseph\'s brothers sold him into slavery in Egypt, yet God was with Joseph from prison to palace, eventually using him to save his entire family from famine.',
      whyThisMatters:
          'As Joseph later told his brothers in Genesis 50:20, "You planned evil against me; God planned it for good to bring about the present result—the survival of many people."',
    ),
    BibleQuestion(
      id: 'q_l1_joshua_jericho',
      questionText: 'How did the walls of Jericho fall when Joshua and the Israelites entered the Promised Land?',
      options: [
        'Israel built siege ramps and battering rams',
        'The army marched around the city for seven days, blew trumpets, and shouted',
        'An earthquake struck while Israel slept in camp',
        'Caleb led a midnight raid through the city gates',
      ],
      correctOptionIndex: 1,
      difficulty: 1,
      sublevel: '1a',
      testament: 'OT',
      book: 'Joshua',
      topic: 'Miracles',
      character: 'Joshua',
      bibleReference: 'Joshua 6:20 (CSB)',
      csbVerseText:
          'So the people shouted, and the trumpets sounded. When the people heard the sound of the trumpet, the people gave a great shout, and the wall collapsed.',
      contextExplainer:
          'Following the Lord\'s unconventional battle plan, Israel marched silently around Jericho once a day for six days, and seven times on the seventh day with priests blowing rams\' horns before shouting.',
      whyThisMatters:
          'Hebrews 11:30 says, "By faith the walls of Jericho fell down after being marched around by the Israelites for seven days." Trusting God\'s word matters more than human military strategy.',
    ),
    BibleQuestion(
      id: 'q_l1_shepherd_psalm',
      questionText: 'Which famous Psalm of David begins with the words, "The Lord is my shepherd; I have what I need"?',
      options: ['Psalm 1', 'Psalm 23', 'Psalm 51', 'Psalm 91'],
      correctOptionIndex: 1,
      difficulty: 1,
      sublevel: '1a',
      testament: 'OT',
      book: 'Psalms',
      topic: 'Wisdom',
      character: 'David',
      bibleReference: 'Psalm 23:1–4 (CSB)',
      csbVerseText:
          'The Lord is my shepherd; I have what I need. He lets me lie down in green pastures; he leads me beside quiet waters. He renews my life; he leads me along the right paths for his name\'s sake.',
      contextExplainer:
          'Drawing on his own youth tending sheep in the Judean hills, David pictured the Lord as a tender, vigilant Shepherd who guides, provides, and walks with His flock even through the darkest valley.',
      whyThisMatters:
          'In John 10:11, Jesus steps directly into Psalm 23 and declares, "I am the good shepherd. The good shepherd lays down his life for the sheep."',
    ),
    BibleQuestion(
      id: 'q_l1_first_miracle',
      questionText: 'What was Jesus\' very first miracle (sign) recorded in the Gospel of John?',
      options: [
        'Healing the blind man at Bethesda',
        'Turning water into wine at a wedding in Cana',
        'Calming the storm on the sea',
        'Raising Lazarus from the dead',
      ],
      correctOptionIndex: 1,
      difficulty: 1,
      sublevel: '1b',
      testament: 'NT',
      book: 'John',
      topic: 'Miracles',
      character: 'Jesus',
      bibleReference: 'John 2:11 (CSB)',
      csbVerseText:
          'Jesus performed this first sign in Cana of Galilee. He displayed his glory, and his disciples believed in him.',
      contextExplainer:
          'At a village wedding celebration in Cana, the wine ran out. Jesus had servants fill six stone water jars used for Jewish purification rites (holding 120–180 gallons) and transformed the water into the finest wine.',
      whyThisMatters:
          'By using stone purification jars, Jesus signaled that He had come to replace external ritual cleansing with the joyful abundance of the Messianic kingdom.',
    ),

    // --- LEVEL 2 (SUNDAY SCHOOL STRONG — INTERMEDIATE) ---
    BibleQuestion(
      id: 'q_l2_ruth_boaz',
      questionText: 'In the Book of Ruth, what did Ruth say to her mother-in-law Naomi when urged to return to Moab?',
      options: [
        '"Send me with your blessing, and I will remember you always."',
        '"Where you go, I will go, and where you stay, I will stay. Your people will be my people, and your God my God."',
        '"Let me glean in the fields of Bethlehem for one harvest season."',
        '"The Lord judge between me and my sister Orpah."',
      ],
      correctOptionIndex: 1,
      difficulty: 2,
      sublevel: '1b',
      testament: 'OT',
      book: 'Ruth',
      topic: 'Character of God',
      character: 'Ruth',
      bibleReference: 'Ruth 1:16 (CSB)',
      csbVerseText:
          'But Ruth replied: Don\'t plead with me to abandon you or to return and not follow you. For wherever you go, I will go, and wherever you live, I will live; your people will be my people, and your God will be my God.',
      contextExplainer:
          'During the dark days of the Judges, Ruth the Moabite clung to widowed Naomi in loyal covenant love (Hebrew: *chesed*), later marrying Boaz the kinsman-redeemer and becoming the great-grandmother of King David.',
      whyThisMatters:
          'Ruth\'s story shows how God weaves a Gentile widow of faith right into the royal lineage of King David and Jesus the Messiah (Matthew 1:5).',
    ),
    BibleQuestion(
      id: 'q_l2_esther_time',
      questionText: 'Who challenged Queen Esther with the famous question, "Who knows, perhaps you have come to your royal position for such a time as this?"',
      options: ['King Ahasuerus (Xerxes)', 'Mordecai', 'Hegai the eunuch', 'Nehemiah'],
      correctOptionIndex: 1,
      difficulty: 2,
      sublevel: '1b',
      testament: 'OT',
      book: 'Esther',
      topic: 'Israel',
      character: 'Esther',
      bibleReference: 'Esther 4:14 (CSB)',
      csbVerseText:
          '"If you keep silent at this time, relief and deliverance will come to the Jewish people from another place, but you and your father\'s family will be destroyed. Who knows, perhaps you have come to your royal position for such a time as this?"',
      contextExplainer:
          'When Haman plotted to annihilate the Jewish people across the Persian Empire, Esther\'s cousin and guardian Mordecai urged her to risk her life by approaching the king unannounced after three days of fasting.',
      whyThisMatters:
          'Even when God\'s name isn\'t spoken out loud, His unseen providence places His people in specific moments and callings to stand for truth and protect the vulnerable.',
    ),
    BibleQuestion(
      id: 'q_l2_solomon_request',
      questionText: 'When God appeared to young King Solomon at Gibeon and said, "Ask. What should I give you?", what did Solomon ask for?',
      options: [
        'Victory over all Israel\'s surrounding enemies',
        'A receptive (discerning) heart to judge God\'s people and discern good from evil',
        'Long life and peace throughout his reign',
        'Gold and cedar timber to build the temple',
      ],
      correctOptionIndex: 1,
      difficulty: 2,
      sublevel: '1b',
      testament: 'OT',
      book: '1 Kings',
      topic: 'Wisdom',
      character: 'Solomon',
      bibleReference: '1 Kings 3:9–10 (CSB)',
      csbVerseText:
          '"So give your servant a receptive heart to judge your people and to discern between good and evil. For who is able to judge this great people of yours?" Now it pleased the Lord that Solomon had requested this.',
      contextExplainer:
          'Literally in Hebrew, Solomon asked for a "listening heart" (*lev shomea*). Pleased that Solomon did not ask for wealth, long life, or the death of his enemies, God granted him unmatched wisdom along with riches and honor.',
      whyThisMatters:
          'True biblical wisdom starts with humility and a listening heart before God ("The fear of the Lord is the beginning of knowledge," Proverbs 1:7; James 1:5).',
    ),
    BibleQuestion(
      id: 'q_l2_abraham_isaac',
      questionText: 'What name did Abraham give the place on Mount Moriah after God provided a ram caught in the thicket in place of Isaac?',
      options: [
        'Bethel ("House of God")',
        'The Lord Will Provide (Yahweh-Yireh)',
        'Ebenezer ("Stone of Help")',
        'Beersheba ("Well of the Oath")',
      ],
      correctOptionIndex: 1,
      difficulty: 2,
      testament: 'OT',
      book: 'Genesis',
      topic: 'Character of God',
      character: 'Abraham',
      bibleReference: 'Genesis 22:13–14 (CSB)',
      csbVerseText:
          'Abraham looked up and saw a ram caught in the thicket by its horns. So Abraham went and took the ram and offered it as a burnt offering in place of his son. And Abraham named that place The Lord Will Provide.',
      contextExplainer:
          'When Isaac asked where the lamb for the burnt offering was, Abraham answered, "God himself will provide the lamb" (Genesis 22:8). At the critical moment, the angel of the Lord stayed Abraham\'s hand and provided a substitute.',
      whyThisMatters:
          'Mount Moriah points directly to Calvary, where God the Father did not spare His own beloved Son, providing Jesus as "the Lamb of God, who takes away the sin of the world" (John 1:29; Romans 8:32).',
    ),
    BibleQuestion(
      id: 'q_l2_road_damascus',
      questionText: 'On the road to which city was Saul of Tarsus blinded by a light from heaven and confronted by the risen Jesus?',
      options: ['Antioch', 'Damascus', 'Tarsus', 'Caesarea'],
      correctOptionIndex: 1,
      difficulty: 2,
      sublevel: '1b',
      testament: 'NT',
      book: 'Acts',
      topic: 'Miracles',
      character: 'Paul',
      bibleReference: 'Acts 9:3–5 (CSB)',
      csbVerseText:
          'As he traveled and was nearing Damascus, a light from heaven suddenly flashed around him. Falling to the ground, he heard a voice saying to him, "Saul, Saul, why are you persecuting me?"',
      contextExplainer:
          'Carrying letters from the high priest to arrest followers of "the Way" in Damascus, Saul encountered the risen Lord, was led blind into the city, and received his sight and baptism through Ananias.',
      whyThisMatters:
          'No one is beyond the reach of God\'s transforming grace: the church\'s fiercest persecutor became its greatest missionary apostle (1 Timothy 1:15–16).',
    ),
    BibleQuestion(
      id: 'q_l2_fruit_spirit',
      questionText: 'In Galatians 5:22–23, which of the following is NOT listed among the ninefold "fruit of the Spirit"?',
      options: ['Patience', 'Gentleness', 'Boldness', 'Self-control'],
      correctOptionIndex: 2,
      difficulty: 2,
      testament: 'NT',
      book: 'Galatians',
      topic: 'Wisdom',
      character: 'Paul',
      bibleReference: 'Galatians 5:22–23 (CSB)',
      csbVerseText:
          'But the fruit of the Spirit is love, joy, peace, patience, kindness, goodness, faithfulness, gentleness, and self-control. The law is not against such things.',
      contextExplainer:
          'While boldness is a wonderful gift of the Spirit in Acts, Paul\'s ninefold list of the *fruit* of the Spirit in Galatians 5 contrasts the works of the flesh with the Christlike character grown by walking in the Spirit.',
      whyThisMatters:
          'Notice Paul uses the singular word "fruit" (not "fruits") — these nine qualities grow together as a unified portrait of Jesus\' own life formed in us by the Holy Spirit.',
    ),
    BibleQuestion(
      id: 'q_l2_sower_parable',
      questionText: 'In the Parable of the Sower (Matthew 13 / Mark 4), what do the thorns that choke the growing plants represent?',
      options: [
        'Satan immediately snatching away the word',
        'Persecution because of the word',
        'The worries of this age, the deceitfulness of wealth, and desires for other things',
        'False prophets teaching another gospel',
      ],
      correctOptionIndex: 2,
      difficulty: 2,
      testament: 'NT',
      book: 'Mark',
      topic: 'Parables',
      character: 'Jesus',
      bibleReference: 'Mark 4:18–19 (CSB)',
      csbVerseText:
          'And others are sown among thorns; these are the ones who hear the word, but the worries of this age, the deceitfulness of wealth, and the desires for other things enter in and choke the word, and it becomes unfruitful.',
      contextExplainer:
          'Jesus describes four soils receiving the same seed (the word of God): the path (hard heart), rocky ground (shallow root under trial), thorny ground (crowded heart), and good soil (yielding 30, 60, and 100 times).',
      whyThisMatters:
          'Spiritual fruitfulness isn\'t only threatened by overt opposition; it is just as often choked out slowly by hurry, anxiety, and materialism.',
    ),
    BibleQuestion(
      id: 'q_l2_armor_god',
      questionText: 'In the "Armor of God" passage in Ephesians 6, which piece is the ONLY offensive weapon mentioned and represents the word of God?',
      options: [
        'The shield of faith',
        'The sword of the Spirit',
        'The breastplate of righteousness',
        'The helmet of salvation',
      ],
      correctOptionIndex: 1,
      difficulty: 2,
      sublevel: '1b',
      testament: 'NT',
      book: 'Ephesians',
      topic: 'Commands & Laws',
      character: 'Paul',
      bibleReference: 'Ephesians 6:17 (CSB)',
      csbVerseText:
          'Take the helmet of salvation and the sword of the Spirit—which is the word of God.',
      contextExplainer:
          'Writing chained to a Roman praetorian guard, Paul describes six pieces of spiritual armor: belt of truth, breastplate of righteousness, sandals of the gospel of peace, shield of faith, helmet of salvation, and the sword of the Spirit.',
      whyThisMatters:
          'Just as Jesus answered every temptation in the wilderness with "It is written," knowing and wielding Scripture is our primary offensive and defensive weapon in spiritual battle.',
    ),
    BibleQuestion(
      id: 'q_l2_sermon_mount',
      questionText: 'In the Beatitudes (Matthew 5:8), what does Jesus promise to "the pure in heart"?',
      options: [
        'They will inherit the earth',
        'They will be called sons of God',
        'They will see God',
        'Theirs is the kingdom of heaven',
      ],
      correctOptionIndex: 2,
      difficulty: 2,
      testament: 'NT',
      book: 'Matthew',
      topic: "Jesus' Life on Earth",
      character: 'Jesus',
      bibleReference: 'Matthew 5:8 (CSB)',
      csbVerseText: 'Blessed are the pure in heart, for they will see God.',
      contextExplainer:
          'Opening the Sermon on the Mount, Jesus echoes Psalm 24:3–4 ("Who may ascend the mountain of the Lord?... The one who has clean hands and a pure heart"). Purity of heart means an undivided, sincere devotion to God.',
      whyThisMatters:
          'Jesus looks past outward religious performance to the inward integrity of the heart — and promises the ultimate reward: beholding God Himself.',
    ),
    BibleQuestion(
      id: 'q_l2_isaiah_suffering',
      questionText: 'Which chapter of Isaiah is known as the "Fourth Servant Song," prophesying that the Messiah would be "pierced because of our rebellion"?',
      options: ['Isaiah 6', 'Isaiah 40', 'Isaiah 53', 'Isaiah 61'],
      correctOptionIndex: 2,
      difficulty: 2,
      testament: 'OT',
      book: 'Isaiah',
      topic: 'Prophecy',
      bibleReference: 'Isaiah 53:5 (CSB)',
      csbVerseText:
          'But he was pierced because of our rebellion, crushed because of our iniquities; punishment for our peace was on him, and we are healed by his wounds.',
      contextExplainer:
          'Beginning in Isaiah 52:13 and running through 53:12, the prophet portrays the Servant of the Lord who suffers silently like a lamb led to slaughter to bear the sin of many.',
      whyThisMatters:
          'New Testament writers quote or allude to Isaiah 53 more than almost any other Old Testament passage (e.g., Acts 8:32–35; 1 Peter 2:22–25) to explain the cross of Christ.',
    ),
    BibleQuestion(
      id: 'q_l2_geography_jordan',
      questionText: 'Into which body of water does the Jordan River flow at its southern end?',
      options: [
        'The Sea of Galilee',
        'The Dead Sea (Salt Sea)',
        'The Red Sea',
        'The Mediterranean Sea',
      ],
      correctOptionIndex: 1,
      difficulty: 2,
      testament: 'OT',
      book: 'Joshua',
      topic: 'Geography',
      bibleReference: 'Joshua 3:16 (CSB)',
      csbVerseText:
          'The water flowing downstream stood still... while the water flowing downstream into the Sea of the Arabah, the Dead Sea, was completely cut off.',
      contextExplainer:
          'The Jordan River originates near Mount Hermon in the north, flows through the Sea of Galilee, and winds southward down the Jordan Rift Valley until it empties into the Dead Sea — the lowest land elevation on earth.',
      whyThisMatters:
          'Understanding the geography of the Promised Land brings scenes like Israel\'s crossing under Joshua, Naaman\'s washing, and Jesus\' baptism by John into vivid focus.',
    ),
    BibleQuestion(
      id: 'q_l2_peter_pentecost',
      questionText: 'Which Old Testament prophet did Peter quote at length on the Day of Pentecost to explain the outpouring of the Holy Spirit?',
      options: ['Joel', 'Amos', 'Habakkuk', 'Zechariah'],
      correctOptionIndex: 0,
      difficulty: 2,
      testament: 'NT',
      book: 'Acts',
      topic: 'Prophecy',
      character: 'Peter',
      bibleReference: 'Acts 2:16–17; Joel 2:28–32 (CSB)',
      csbVerseText:
          'On the contrary, this is what was spoken through the prophet Joel: "And it will be in the last days, says God, that I will pour out my Spirit on all people."',
      contextExplainer:
          'Fifty days after Passover, the Holy Spirit descended on the believers in Jerusalem. Peter stood up and preached from Joel 2 and Psalms 16 and 110, and about 3,000 people were baptized that day.',
      whyThisMatters:
          'Pentecost fulfilled the Old Testament hope that God\'s Spirit would no longer rest only on select kings and prophets, but on all sons and daughters who call on the name of the Lord.',
    ),

    // --- LEVEL 3 (SEMINARY ENERGY — ADVANCED) ---
    BibleQuestion(
      id: 'q_l3_hebrews_melchizedek',
      questionText: 'According to Hebrews 7 (echoing Psalm 110:4), after whose priestly order is Jesus appointed a high priest forever?',
      options: [
        'The order of Aaron',
        'The order of Zadok',
        'The order of Melchizedek',
        'The order of Phinehas',
      ],
      correctOptionIndex: 2,
      difficulty: 3,
      testament: 'NT',
      book: 'Hebrews',
      topic: 'Prophecy',
      character: 'Jesus',
      bibleReference: 'Hebrews 7:17; Psalm 110:4 (CSB)',
      csbVerseText:
          'For it has been testified: "You are a priest forever according to the order of Melchizedek."',
      contextExplainer:
          'Melchizedek appears briefly in Genesis 14:18–20 as both King of Salem ("King of Peace") and priest of God Most High, blessing Abraham. Because Jesus was from the tribe of Judah rather than Levi, His royal priesthood fulfills Psalm 110:4.',
      whyThisMatters:
          'Unlike Levitical priests whose ministry ended in death, Jesus unites the offices of righteous King and eternal High Priest who ever lives to intercede for us (Hebrews 7:25).',
      whyThisDiffers:
          'Some early Jewish and Christian interpreters wondered whether Melchizedek was a pre-incarnate appearance of Christ, while most scholars view him as a historical Canaanite priest-king who serves as a literary and theological type of Christ.',
    ),
    BibleQuestion(
      id: 'q_l3_josiah_scroll',
      questionText: 'Which priest discovered the lost "book of the law" in the temple during the eighteenth year of King Josiah\'s reign?',
      options: ['Jehoiada', 'Hilkiah', 'Ezra', 'Eliashib'],
      correctOptionIndex: 1,
      difficulty: 3,
      testament: 'OT',
      book: '2 Kings',
      topic: 'Israel',
      bibleReference: '2 Kings 22:8 (CSB)',
      csbVerseText:
          'The high priest Hilkiah told the court secretary Shaphan, "I have found the book of the law in the Lord\'s temple," and he gave the book to Shaphan, who read it.',
      contextExplainer:
          'After decades of idolatry under Manasseh and Amon, 26-year-old King Josiah ordered repairs on the temple. High priest Hilkiah found the scroll of the Law (likely Deuteronomy); when Shaphan read it aloud, Josiah tore his clothes in repentance and led a sweeping covenant renewal.',
      whyThisMatters:
          'Every true spiritual awakening in history begins the same way Josiah\'s reformation did: rediscovering the neglected Word of God and humbling our hearts under it.',
    ),
    BibleQuestion(
      id: 'q_l3_paul_areopagus',
      questionText: 'When Paul addressed the Epicurean and Stoic philosophers at the Areopagus in Athens (Acts 17), what inscription on an altar did he use as his starting point?',
      options: [
        '"TO THE LORD OF HEAVEN AND EARTH"',
        '"TO AN UNKNOWN GOD"',
        '"TO THE IMMORTAL LOGOS"',
        '"TO ZEUS THE DELIVERER"',
      ],
      correctOptionIndex: 1,
      difficulty: 3,
      testament: 'NT',
      book: 'Acts',
      topic: 'Geography',
      character: 'Paul',
      bibleReference: 'Acts 17:22–23 (CSB)',
      csbVerseText:
          '"Men of Athens! I see that you are extremely religious in every respect. For as I was passing through and observing the objects of your worship, I even found an altar on which was inscribed, \'To an Unknown God.\' Therefore, what you worship in ignorance, this I proclaim to you."',
      contextExplainer:
          'Rather than quoting Hebrew prophets to pagan Greek philosophers, Paul built a bridge from their own altar and poets (Epimenides and Aratus: "In him we live and move and have our being") before proclaiming the Creator and the resurrection of Jesus.',
      whyThisMatters:
          'Acts 17 is a masterclass in thoughtful cultural engagement: discerning the spiritual hunger beneath a culture\'s idols and pointing clearly to the risen Christ.',
    ),
    BibleQuestion(
      id: 'q_l3_leviticus_atonement',
      questionText: 'In Leviticus 16, what was the Hebrew term (often translated "scapegoat") associated with the second goat sent into the wilderness on the Day of Atonement?',
      options: ['Azazel', 'Kippur', 'Corban', 'Cherem'],
      correctOptionIndex: 0,
      difficulty: 3,
      testament: 'OT',
      book: 'Leviticus',
      topic: 'Commands & Laws',
      character: 'Moses',
      bibleReference: 'Leviticus 16:8–10 (CSB)',
      csbVerseText:
          'Aaron is to cast lots for the two goats, one lot for the Lord and the other for Azazel... the goat on which the lot for Azazel fell is to be presented alive before the Lord to make atonement with it by sending it into the wilderness.',
      contextExplainer:
          'On Yom Kippur (the Day of Atonement), two goats pictured two sides of atonement: one was sacrificed as a sin offering to cleanse the sanctuary, and over the second goat Aaron confessed all Israel\'s sins before sending it away into the wilderness.',
      whyThisMatters:
          'Together, the two goats foreshadow Christ\'s cross: He both paid the penalty of sin with His blood (propitiation) and carried our guilt completely out of sight ("as far as the east is from the west," Psalm 103:12; Hebrews 9:12).',
      whyThisDiffers:
          'Translators and scholars debate the exact etymology of "Azazel": some render it "scapegoat" ("the goat that departs"), others as a rugged wilderness cliff, and others as a symbolic figure of wasteland desolation.',
    ),
    BibleQuestion(
      id: 'q_l3_romans_propitiation',
      questionText: 'In Romans 3:25, Paul writes that God presented Jesus as a "mercy seat" / "atoning sacrifice" (Greek: *hilasterion*). What Old Testament object did *hilasterion* refer to in the Greek Septuagint?',
      options: [
        'The bronze altar of burnt offering',
        'The golden cover (atonement lid) of the ark of the covenant',
        'The table of the bread of the Presence',
        'The bronze basin for washing',
      ],
      correctOptionIndex: 1,
      difficulty: 3,
      testament: 'NT',
      book: 'Romans',
      topic: 'Character of God',
      character: 'Paul',
      bibleReference: 'Romans 3:25 (CSB)',
      csbVerseText:
          'God presented him as the mercy seat by his blood, through faith, to demonstrate his righteousness, because in his restraint God passed over the sins previously committed.',
      contextExplainer:
          'In the Septuagint (Greek OT) of Exodus 25:17 and Leviticus 16:14, *hilasterion* is the exact term for the solid gold lid over the Ark of the Covenant where blood was sprinkled on the Day of Atonement.',
      whyThisMatters:
          'Paul announces that the true meeting place between a holy God and forgiven sinners is no longer a golden box behind a curtain in Jerusalem — it is the cross of Jesus Christ.',
    ),
    BibleQuestion(
      id: 'q_l3_revelation_laodicea',
      questionText: 'Which of the seven churches in Revelation 2–3 did Jesus rebuke for being "lukewarm, and neither hot nor cold"?',
      options: ['Ephesus', 'Sardis', 'Philadelphia', 'Laodicea'],
      correctOptionIndex: 3,
      difficulty: 3,
      testament: 'NT',
      book: 'Revelation',
      topic: 'Prophecy',
      character: 'Jesus',
      bibleReference: 'Revelation 3:15–16 (CSB)',
      csbVerseText:
          '"I know your works, that you are neither cold nor hot. I wish that you were cold or hot. So, because you are lukewarm, and neither hot nor cold, I am going to vomit you out of my mouth."',
      contextExplainer:
          'Neighboring Hierapolis was famous for hot medicinal springs, and Colossae was known for cold, refreshing mountain water. Wealthy Laodicea had to pipe water in through aqueducts, arriving tepid and mineral-heavy.',
      whyThisMatters:
          'Rather than contrasting "on fire for God" with "spiritually dead," Jesus used local geography to call Laodicea to be either healing like Hierapolis\'s hot springs or refreshing like Colossae\'s cold streams, instead of spiritually complacent and useless.',
    ),
    BibleQuestion(
      id: 'q_l3_deuteronomy_shema',
      questionText: 'Where in the Torah is the *Shema* — "Listen, Israel: The Lord our God, the Lord is one. Love the Lord your God with all your heart, with all your soul, and with all your strength" — found?',
      options: [
        'Exodus 20:2–3',
        'Leviticus 19:18',
        'Deuteronomy 6:4–5',
        'Numbers 6:24–26',
      ],
      correctOptionIndex: 2,
      difficulty: 3,
      testament: 'OT',
      book: 'Deuteronomy',
      topic: 'Commands & Laws',
      character: 'Moses',
      bibleReference: 'Deuteronomy 6:4–5 (CSB)',
      csbVerseText:
          'Listen, Israel: The Lord our God, the Lord is one. Love the Lord your God with all your heart, with all your soul, and with all your strength.',
      contextExplainer:
          'Named after its first Hebrew word (*Shema*, "Listen/Hear"), Deuteronomy 6:4–5 is the foundational confession of Israel\'s faith, which Jesus identified in Mark 12:29–30 as the greatest commandment in the Law.',
      whyThisMatters:
          'Because there is only one true God, our devotion to Him cannot be divided — He claims all our heart, soul, mind, and strength.',
    ),
    BibleQuestion(
      id: 'q_l3_job_redeemer',
      questionText: 'In the midst of his suffering, who declared in the Old Testament, "But I know that my Redeemer lives, and at the end he will stand on the dust"?',
      options: ['Job', 'Jeremiah', 'David', 'Asaph'],
      correctOptionIndex: 0,
      difficulty: 3,
      testament: 'OT',
      book: 'Job',
      topic: 'Wisdom',
      bibleReference: 'Job 19:25 (CSB)',
      csbVerseText:
          'But I know that my Redeemer lives, and at the end he will stand on the dust.',
      contextExplainer:
          'Stripped of health, wealth, children, and the sympathy of his friends, Job appealed beyond human courts to a heavenly *Go\'el* (Kinsman-Redeemer / Vindicator) who would ultimately stand upon the earth and vindicate him.',
      whyThisMatters:
          'Job\'s cry of defiant hope in the dark anticipates the resurrection of Jesus Christ, our living Redeemer.',
    ),
    BibleQuestion(
      id: 'q_l3_philippians_kenosis',
      questionText: 'Which chapter of Paul\'s letters contains the famous "Christ Hymn" (*Kenosis*), describing how Jesus "emptied himself by assuming the form of a servant"?',
      options: [
        'Colossians 1',
        'Philippians 2',
        '1 Corinthians 15',
        'Ephesians 1',
      ],
      correctOptionIndex: 1,
      difficulty: 3,
      testament: 'NT',
      book: 'Philippians',
      topic: "Jesus' Life on Earth",
      character: 'Paul',
      bibleReference: 'Philippians 2:6–8 (CSB)',
      csbVerseText:
          'Who, existing in the form of God, did not consider equality with God as something to be exploited. Instead he emptied himself by assuming the form of a servant, taking on the likeness of humanity.',
      contextExplainer:
          'In Philippians 2:5–11, Paul grounds practical Christian unity and humility in the breathtaking downward mobility of the Son of God — from heaven\'s throne to a Roman cross — followed by His exaltation as Lord of all.',
      whyThisMatters:
          'In God\'s kingdom, the path to greatness is downward: humble, self-giving service modeled on Jesus Himself.',
    ),
    BibleQuestion(
      id: 'q_l3_jeremiah_new_covenant',
      questionText: 'Which Old Testament prophet explicitly foretold a "new covenant" in which God would put His teaching within His people and write it on their hearts?',
      options: ['Hosea', 'Jeremiah', 'Malachi', 'Micah'],
      correctOptionIndex: 1,
      difficulty: 3,
      testament: 'OT',
      book: 'Jeremiah',
      topic: 'Prophecy',
      bibleReference: 'Jeremiah 31:31, 33 (CSB)',
      csbVerseText:
          '"Look, the days are coming"—this is the Lord\'s declaration—"when I will make a new covenant with the house of Israel and with the house of Judah... I will put my teaching within them and write it on their hearts."',
      contextExplainer:
          'Speaking as Jerusalem neared exile for breaking the Sinai covenant, Jeremiah 31:31–34 promised a future covenant of internal transformation and complete forgiveness of sins.',
      whyThisMatters:
          'At the Last Supper, Jesus lifted the cup and said, "This cup is the new covenant in my blood" (Luke 22:20; Hebrews 8:8–12), inaugurating Jeremiah\'s promise.',
    ),
    BibleQuestion(
      id: 'q_l3_exodus_name',
      questionText: 'In Exodus 34:6–7, when the Lord passed before Moses in the cleft of the rock and proclaimed His name, what were the first two attributes He declared?',
      options: [
        '"Sovereign and Almighty"',
        '"Compassionate and gracious"',
        '"Holy and consuming fire"',
        '"Righteous and avenging"',
      ],
      correctOptionIndex: 1,
      difficulty: 3,
      testament: 'OT',
      book: 'Exodus',
      topic: 'Character of God',
      character: 'Moses',
      bibleReference: 'Exodus 34:6 (CSB)',
      csbVerseText:
          'The Lord passed in front of him and proclaimed: The Lord—the Lord is a compassionate and gracious God, slow to anger and abounding in faithful love and truth.',
      contextExplainer:
          'Right after Israel\'s golden calf rebellion, Moses asked to see God\'s glory. God revealed His deepest character in Exodus 34:6–7 — the most frequently quoted verse inside the Bible itself (echoed in Numbers, Nehemiah, Psalms, Joel, Jonah, and Nahum).',
      whyThisMatters:
          'When God defines Himself in Scripture, He leads with compassion, grace, patience, and covenant loyalty (*chesed*).',
    ),
    BibleQuestion(
      id: 'q_l2_james_faith',
      questionText: 'How does James 2:17 describe faith that is not accompanied by works?',
      options: [
        'Weak, but growing',
        'Dead, being by itself',
        'Hidden in the heart',
        'A seed waiting for rain',
      ],
      correctOptionIndex: 1,
      difficulty: 2,
      testament: 'NT',
      book: 'James',
      topic: 'Wisdom',
      bibleReference: 'James 2:17 (CSB)',
      csbVerseText:
          'In the same way faith, if it doesn\'t have works, is dead by itself.',
      contextExplainer:
          'James addresses people who claim to have faith while ignoring the practical needs of hungry and cold brothers and sisters. True, living faith inevitably expresses itself in loving action.',
      whyThisMatters:
          'As the Reformers summarized Paul and James: we are saved by faith alone, but the faith that saves is never alone.',
      whyThisDiffers:
          'While Paul uses "works" (specifically "works of the law") to refute earning salvation by merit, James uses "works" to describe the visible fruit that proves faith is genuine rather than mere verbal agreement.',
    ),
  ];

  /// Returns a curated 5-question Daily 5 set (2×L1, 2×L2, 1×L3) deterministic for a given date.
  static List<BibleQuestion> getDaily5Questions([DateTime? date]) {
    final now = date ?? DateTime.now();
    final seed = now.year * 1000 + now.month * 50 + now.day;

    final l1 = allQuestions.where((q) => q.difficulty == 1).toList();
    final l2 = allQuestions.where((q) => q.difficulty == 2).toList();
    final l3 = allQuestions.where((q) => q.difficulty == 3).toList();

    return [
      l1[seed % l1.length],
      l1[(seed + 3) % l1.length],
      l2[seed % l2.length],
      l2[(seed + 2) % l2.length],
      l3[seed % l3.length],
    ];
  }

  /// Returns the 6 official Placement Quiz questions.
  static List<BibleQuestion> getPlacementQuestions() {
    return allQuestions.take(6).toList();
  }

  /// Filters questions for Free Play, Family Mode, or H2H.
  static List<BibleQuestion> filterQuestions({
    int? difficulty, // null if mixAllLevels
    String? sublevel, // '1a' or '1b' for Family Mode
    String? filterType, // 'surprise', 'testament', 'topic', 'character', 'book'
    String? filterValue,
    int count = 5,
  }) {
    Iterable<BibleQuestion> pool = allQuestions;

    if (sublevel != null) {
      if (sublevel == '1a') {
        pool = pool.where((q) => q.sublevel == '1a' || q.difficulty == 1);
      } else {
        pool = pool.where((q) => q.difficulty <= 2);
      }
    } else if (difficulty != null && difficulty > 0) {
      pool = pool.where((q) => q.difficulty == difficulty);
    }

    if (filterType != null &&
        filterType != 'surprise' &&
        filterType != 'any' &&
        filterValue != null &&
        filterValue.isNotEmpty) {
      switch (filterType) {
        case 'testament':
          pool = pool.where((q) => q.testament == filterValue);
          break;
        case 'topic':
          pool = pool.where((q) => q.topic == filterValue);
          break;
        case 'character':
          pool = pool.where((q) => q.character == filterValue);
          break;
        case 'book':
          pool = pool.where((q) => q.book == filterValue);
          break;
      }
    }

    var results = pool.toList();
    if (results.length < count) {
      // Top up with remaining questions so user always gets full desired length
      final existingIds = results.map((e) => e.id).toSet();
      final extras = allQuestions.where((q) => !existingIds.contains(q.id)).toList();
      results = [...results, ...extras];
    }

    return results.take(count).toList();
  }
}
