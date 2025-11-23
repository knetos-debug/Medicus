/// Swedish medical reference URLs and whitelist for clinical decision support
///
/// WHITELIST: Only these domains are trusted for medical information
/// AI must search these sources BEFORE answering any medical question
class MedicalReferences {
  // ═══════════════════════════════════════════════════════════
  // WHITELISTED DOMAINS (AI can ONLY use these)
  // ═══════════════════════════════════════════════════════════

  /// Primary sources (always search these first)
  static const List<String> primaryDomains = [
    'fass.se',                    // Drug information
    'vardhandboken.se',           // Clinical guidelines
    'lakemedelsboken.se',         // Pharmacology
    'vardpersonal.1177.se',       // Professional knowledge + local guidelines
  ];

  /// Secondary sources (use when needed)
  static const List<String> secondaryDomains = [
    'socialstyrelsen.se',         // National guidelines
    'janusinfo.se',               // Drug interactions
    'internetmedicin.se',         // Disease information
    'cancercentrum.se',           // Cancer care programs
  ];

  /// Tertiary sources (international guidelines)
  static const List<String> tertiaryDomains = [
    'escardio.org',               // ESC guidelines
    'nice.org.uk',                // NICE guidelines
  ];

  /// All whitelisted domains combined
  static List<String> get allWhitelistedDomains =>
      [...primaryDomains, ...secondaryDomains, ...tertiaryDomains];

  // ═══════════════════════════════════════════════════════════
  // STABLE SEARCH URLs
  // ═══════════════════════════════════════════════════════════

  /// FASS search - Use this format for ALL drug lookups
  /// Example: https://www.fass.se/LIF/produktfakta/sok/?query=metformin
  static const String fassSearch = 'https://www.fass.se/LIF/produktfakta/sok/?query=';

  /// Vårdhandboken search - Use this for clinical guidelines and procedures
  /// Example: https://www.vardhandboken.se/sok/?q=diabetes
  static const String vardhandbokenSearch = 'https://www.vardhandboken.se/sok/?q=';

  /// 1177 Vårdpersonal search - Professional clinical knowledge
  /// Example: https://vardpersonal.1177.se/kunskapsstod/kliniska-kunskapsstod/
  static const String vardpersonal1177Base = 'https://vardpersonal.1177.se';

  /// Internetmedicin search - Use this for disease information
  /// Example: https://www.internetmedicin.se/search?q=hypertoni
  static const String internetMedicinSearch = 'https://www.internetmedicin.se/search?q=';

  /// Janusinfo search - Use this for regional drug information
  /// Example: https://janusinfo.se/?s=interaktioner
  static const String janusinfoSearch = 'https://janusinfo.se/?s=';

  // STABLE HOME URLs - Use these for general references

  /// FASS - Swedish drug information database (home page)
  static const String fass = 'https://www.fass.se';

  /// Vårdhandboken - Swedish healthcare handbook (home page)
  static const String vardhandboken = 'https://www.vardhandboken.se';

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

  // National Care Programs

  /// Cancercentrum - National cancer care programs
  static const String cancercentrum = 'https://cancercentrum.se/samverkan/vara-uppdrag/kunskapsstyrning/vardprogram';

  /// Nationella riktlinjer - National guidelines portal
  static const String nationellaRiktlinjer = 'https://www.socialstyrelsen.se/kunskapsstod-och-regler/regler-och-riktlinjer/nationella-riktlinjer';

  // International Guidelines

  /// European Society of Cardiology Guidelines
  static const String escGuidelines = 'https://www.escardio.org/Guidelines';

  /// NICE Guidelines (UK)
  static const String niceGuidance = 'https://www.nice.org.uk/guidance';

  /// UpToDate (requires subscription)
  static const String uptodate = 'https://www.uptodate.com';

  /// PubMed - Medical literature search
  /// Example: https://pubmed.ncbi.nlm.nih.gov/?term=hypertension
  static const String pubmedSearch = 'https://pubmed.ncbi.nlm.nih.gov/?term=';

  /// Comprehensive reference list for system prompt
  static const String referencesGuide = '''
## WHITELISTED SOURCES (MANDATORY)

⚠️ Du FÅR ENDAST använda information från dessa källor!
⚠️ ALL information MÅSTE komma från aktuella sökresultat, INTE träningsdata!

### PRIMÄRA KÄLLOR (Sök här FÖRST):

1. **FASS** (fass.se)
   - Läkemedelsinformation, doseringar, interaktioner
   - ALLTID första källan för läkemedel!

2. **Vårdhandboken** (vardhandboken.se)
   - Svenska kliniska riktlinjer
   - Evidensbaserade vårdprogram

3. **Läkemedelsboken** (lakemedelsboken.se)
   - Farmakologisk kunskap
   - Terapeutiska principer

4. **1177 Vårdpersonal** (vardpersonal.1177.se)
   - Kliniskt kunskapsstöd
   - Lokala rutiner och riktlinjer
   - Regional information

### SEKUNDÄRA KÄLLOR (Vid behov):

5. **Socialstyrelsen** (socialstyrelsen.se)
   - Nationella riktlinjer
   - Vårdprogram

6. **Janusinfo** (janusinfo.se)
   - Läkemedelsinteraktioner
   - Regional läkemedelsinformation

7. **Internetmedicin** (internetmedicin.se)
   - Sjukdomsinformation
   - Medicinska uppslagsverk

8. **Cancercentrum** (cancercentrum.se)
   - Nationella cancervårdprogram

### TERTIÄRA KÄLLOR (Internationellt):

9. **ESC** (escardio.org) - Kardiologiriktlinjer
10. **NICE** (nice.org.uk) - Brittiska riktlinjer

### ALLA ANDRA KÄLLOR ÄR FÖRBJUDNA!
''';

  /// Instructions for AI on inline citation format
  static const String referenceFormatInstructions = '''
## INLINE CITAT - OBLIGATORISKT FORMAT

### GRUNDREGEL:
Placera [Källa-Ämne] DIREKT efter VARJE påstående!

### FORMAT:

**Enkel källa:**
"Metformin är förstahandsval vid diabetes typ 2 [Vårdhandboken-Diabetes]."

**Flera källor:**
"Startdos 500-850 mg x2 dagligen [FASS-Metformin, Vårdhandboken-Diabetes]."

**Med sektion:**
"Kontraindicerat vid eGFR <30 ml/min [FASS-Metformin, Kontraindikationer]."

### FULLSTÄNDIGT EXEMPEL:

"METFORMIN VID NJURSVIKT

Normal njurfunktion (eGFR >60):
Startdos 500-850 mg x2 dagligen [FASS-Metformin].
Maxdos 2000-3000 mg/dag [FASS-Metformin, Dosering].

Måttligt nedsatt (eGFR 30-45):
Maxdos 1000 mg/dag [FASS-Metformin, Dosering vid njursvikt].
Regelbunden monitorering rekommenderas [Vårdhandboken-Diabetes, Njursvikt].

Svårt nedsatt (eGFR <30):
KONTRAINDICERAT [FASS-Metformin, Kontraindikationer]."

### KÄLLNAMN ATT ANVÄNDA:

- FASS-[Läkemedelsnamn]
- Vårdhandboken-[Ämne]
- Läkemedelsboken-[Ämne]
- 1177Vårdpersonal-[Ämne]
- Socialstyrelsen-[Ämne]
- Janusinfo-[Ämne]
- Internetmedicin-[Ämne]
- ESC-[Guideline]
- NICE-[Guideline]

### KRITISKA REGLER:

✅ **KORREKT:**
- Inline direkt efter påståendet
- Tydlig källangivelse
- Lätt att se exakt vad som kommer varifrån

❌ **FELAKTIGT:**
- Källor samlade i slutet
- Otydligt vad som hör till vad
- Inga inline-citat alls

**KOM IHÅG: Varje medicinsk fakta MÅSTE ha sin källa inline!**
''';
}
