/// Swedish medical reference URLs for clinical decision support
///
/// This file contains URLs to authoritative Swedish medical sources
/// that should be referenced in AI responses to allow doctors to verify information.
class MedicalReferences {
  // Primary Swedish Medical Resources

  /// Vårdhandboken - Swedish healthcare handbook
  static const String vardhandboken = 'https://www.vardhandboken.se';

  /// FASS - Swedish drug information database
  static const String fass = 'https://www.fass.se';

  /// Läkemedelsboken - Swedish pharmacology textbook
  static const String lakemedelsboken = 'https://lakemedelsboken.se';

  /// 1177 Vårdguiden - Swedish healthcare guide
  static const String vardguiden1177 = 'https://www.1177.se';

  /// Socialstyrelsen - Swedish National Board of Health and Welfare
  static const String socialstyrelsen = 'https://www.socialstyrelsen.se';

  /// Internetmedicin - Swedish medical knowledge base
  static const String internetmedicin = 'https://www.internetmedicin.se';

  /// Janusinfo - Stockholm region drug information
  static const String janusinfo = 'https://janusinfo.se';

  /// Läkemedelsverket - Swedish Medical Products Agency
  static const String lakemedelsverket = 'https://www.lakemedelsverket.se';

  // National Care Programs (Nationella vårdprogram)

  /// Cancercentrum - National cancer care programs
  static const String cancercentrum = 'https://cancercentrum.se/samverkan/vara-uppdrag/kunskapsstyrning/vardprogram';

  /// Nationella riktlinjer - National guidelines portal
  static const String nationellaRiktlinjer = 'https://www.socialstyrelsen.se/kunskapsstod-och-regler/regler-och-riktlinjer/nationella-riktlinjer';

  // International Guidelines (commonly used in Sweden)

  /// European Society of Cardiology
  static const String esc = 'https://www.escardio.org/Guidelines';

  /// National Institute for Health and Care Excellence (UK)
  static const String nice = 'https://www.nice.org.uk/guidance';

  /// UpToDate - Clinical decision support
  static const String uptodate = 'https://www.uptodate.com';

  /// PubMed - Medical literature database
  static const String pubmed = 'https://pubmed.ncbi.nlm.nih.gov';

  // Specific Topic URLs

  /// Map of common medical topics to their Vårdhandboken URLs
  static const Map<String, String> vardhandbokenTopics = {
    'antibiotika': 'https://www.vardhandboken.se/behandling/lakemedel/lakemedel-a-o/antibiotika',
    'diabetes': 'https://www.vardhandboken.se/vard-och-behandling/sjukdomar-och-besvar/endokrina-sjukdomar/diabetes-mellitus',
    'hjartsvikt': 'https://www.vardhandboken.se/vard-och-behandling/sjukdomar-och-besvar/hjarta-och-karlorgan/hjartsvikt',
    'hypertoni': 'https://www.vardhandboken.se/vard-och-behandling/sjukdomar-och-besvar/hjarta-och-karlorgan/hypertoni',
    'astma': 'https://www.vardhandboken.se/vard-och-behandling/sjukdomar-och-besvar/andningsvagar/astma',
    'kol': 'https://www.vardhandboken.se/vard-och-behandling/sjukdomar-och-besvar/andningsvagar/kroniskt-obstruktiv-lungsjukdom-kol',
    'depression': 'https://www.vardhandboken.se/vard-och-behandling/sjukdomar-och-besvar/psykisk-ohalsa/depression',
    'sepsis': 'https://www.vardhandboken.se/vard-och-behandling/sjukdomar-och-besvar/infektioner/sepsis',
  };

  /// Map of drug categories to FASS search URLs
  static Map<String, String> getFassSearchUrl(String drugName) {
    final encodedDrug = Uri.encodeComponent(drugName);
    return {
      'search': 'https://www.fass.se/LIF/produktfakta/sok/?query=$encodedDrug',
    };
  }

  /// Get Internetmedicin search URL
  static String getInternetMedicinSearchUrl(String topic) {
    final encodedTopic = Uri.encodeComponent(topic);
    return 'https://www.internetmedicin.se/search?q=$encodedTopic';
  }

  /// Get Vårdhandboken search URL
  static String getVardhandbokenSearchUrl(String topic) {
    final encodedTopic = Uri.encodeComponent(topic);
    return 'https://www.vardhandboken.se/sok/?q=$encodedTopic';
  }

  /// Comprehensive reference list for system prompt
  static const String referencesGuide = '''
## VIKTIGA SVENSKA MEDICINSKA KÄLLOR

### Läkemedel och doseringar:
- **FASS** (https://www.fass.se) - Läkemedelsinformation, doseringar, interaktioner
- **Läkemedelsboken** (https://lakemedelsboken.se) - Terapeutisk läkemedelsguide
- **Janusinfo** (https://janusinfo.se) - Regional läkemedelsinformation Stockholm

### Kliniska riktlinjer:
- **Vårdhandboken** (https://www.vardhandboken.se) - Nationellt kliniskt kunskapsstöd
- **Socialstyrelsen** (https://www.socialstyrelsen.se) - Nationella riktlinjer och vårdprogram
- **Cancercentrum** (https://cancercentrum.se/samverkan/vara-uppdrag/kunskapsstyrning/vardprogram) - Nationella vårdprogram cancer
- **Internetmedicin** (https://www.internetmedicin.se) - Kunskapsbank för läkare

### Patientinformation:
- **1177 Vårdguiden** (https://www.1177.se) - Patientinformation och vårdkontakt

### Internationella riktlinjer:
- **ESC Guidelines** (https://www.escardio.org/Guidelines) - Europeiska kardiologförbundet
- **NICE** (https://www.nice.org.uk/guidance) - Brittiska riktlinjer
- **UpToDate** (https://www.uptodate.com) - Evidensbaserat beslutsstöd

### Forskning:
- **PubMed** (https://pubmed.ncbi.nlm.nih.gov) - Medicinsk litteratur
''';

  /// Instructions for AI on how to format references
  static const String referenceFormatInstructions = '''
## SÅ HÄR FORMATERAR DU REFERENSER

Använd ALLTID klickbara markdown-länkar när du refererar till källor:

### Format:
**[Källnamn - Specifikt ämne](URL)**

### Exempel på korrekt formatering:

1. **Efter en läkemedelsrekommendation:**
   "Metformin 500-1000 mg x2 är förstahandsval vid typ 2-diabetes."

   **Källor:**
   - [FASS - Metformin](https://www.fass.se/LIF/produktfakta/sok/?query=metformin)
   - [Vårdhandboken - Diabetes mellitus typ 2](https://www.vardhandboken.se/vard-och-behandling/sjukdomar-och-besvar/endokrina-sjukdomar/diabetes-mellitus)

2. **Efter en diagnostisk rekommendation:**
   "Vid misstänkt hjärtsvikt: BNP/NT-proBNP, EKG, ekokardiografi."

   **Källor:**
   - [Vårdhandboken - Hjärtsvikt](https://www.vardhandboken.se/vard-och-behandling/sjukdomar-och-besvar/hjarta-och-karlorgan/hjartsvikt)
   - [ESC Heart Failure Guidelines](https://www.escardio.org/Guidelines)

3. **Vid läkemedelsinteraktioner:**
   "Warfarin och makrolider: ökad blödningsrisk. Överväg dosjustering."

   **Källor:**
   - [FASS - Warfarin](https://www.fass.se/LIF/produktfakta/sok/?query=warfarin)
   - [Janusinfo - Läkemedelsinteraktioner](https://janusinfo.se)

### Viktiga principer:
- Lägg ALLTID till källor direkt efter varje viktig rekommendation
- Använd specifika URLs när möjligt (inte bara startsidor)
- För läkemedel: länka till FASS
- För sjukdomar/tillstånd: länka till Vårdhandboken eller Internetmedicin
- För nationella riktlinjer: länka till Socialstyrelsen eller Cancercentrum
- För internationella guidelines: länka till ESC, NICE, etc.
- Placera källor i en egen **Källor:**-sektion direkt under relevant text
''';
}
