/// Swedish medical reference URLs for clinical decision support
///
/// IMPORTANT: These URLs are VERIFIED and STABLE. Do not generate new URLs.
/// All URLs use search endpoints or stable home pages to avoid 404 errors.
class MedicalReferences {
  // STABLE SEARCH URLs - These are the ONLY URLs the AI should use

  /// FASS search - Use this format for ALL drug lookups
  /// Example: https://www.fass.se/LIF/produktfakta/sok/?query=metformin
  static const String fassSearch = 'https://www.fass.se/LIF/produktfakta/sok/?query=';

  /// Vårdhandboken search - Use this for clinical guidelines and procedures
  /// Example: https://www.vardhandboken.se/sok/?q=diabetes
  static const String vardhandbokenSearch = 'https://www.vardhandboken.se/sok/?q=';

  /// Internetmedicin search - Use this for disease information
  /// Example: https://www.internetmedicin.se/search?q=hypertoni
  static const String internetMedicinSearch = 'https://www.internetmedicin.se/search?q=';

  /// Janusinfo search - Use this for regional drug information
  /// Example: https://janusinfo.se/?s=interaktioner
  static const String janusinfoSearch = 'https://janusinfo.se/?s=';

  /// 1177 search - Use this for patient information
  /// Example: https://www.1177.se/hitta-vard/sök/?q=diabetes
  static const String vardguiden1177Search = 'https://www.1177.se/hitta-vard/sok/?q=';

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
## TILLÅTNA SVENSKA MEDICINSKA KÄLLOR

⚠️ VIKTIGT: Använd ENDAST dessa URL-format. Generera ALDRIG egna URLs!

### Läkemedel och doseringar:

**FASS - För ALLA läkemedel:**
Format: https://www.fass.se/LIF/produktfakta/sok/?query=LÄKEMEDELSNAMN
Exempel:
- [FASS - Metformin](https://www.fass.se/LIF/produktfakta/sok/?query=metformin)
- [FASS - Enalapril](https://www.fass.se/LIF/produktfakta/sok/?query=enalapril)
- [FASS - Simvastatin](https://www.fass.se/LIF/produktfakta/sok/?query=simvastatin)

**Läkemedelsboken - Allmän farmakologi:**
- [Läkemedelsboken](https://lakemedelsboken.se)

**Janusinfo - Läkemedelsinteraktioner:**
Format: https://janusinfo.se/?s=SÖKTERM
Exempel: [Janusinfo - Interaktioner](https://janusinfo.se/?s=interaktioner)

### Kliniska riktlinjer och sjukdomar:

**Vårdhandboken - För kliniska riktlinjer:**
Format: https://www.vardhandboken.se/sok/?q=SJUKDOM
Exempel:
- [Vårdhandboken - Diabetes](https://www.vardhandboken.se/sok/?q=diabetes)
- [Vårdhandboken - Hypertoni](https://www.vardhandboken.se/sok/?q=hypertoni)
- [Vårdhandboken - Hjärtsvikt](https://www.vardhandboken.se/sok/?q=hjartsvikt)

**Internetmedicin - För sjukdomsinformation:**
Format: https://www.internetmedicin.se/search?q=SJUKDOM
Exempel:
- [Internetmedicin - Hypertoni](https://www.internetmedicin.se/search?q=hypertoni)
- [Internetmedicin - Astma](https://www.internetmedicin.se/search?q=astma)

**Nationella riktlinjer:**
- [Socialstyrelsen - Nationella riktlinjer](https://www.socialstyrelsen.se/kunskapsstod-och-regler/regler-och-riktlinjer/nationella-riktlinjer)
- [Cancercentrum - Vårdprogram](https://cancercentrum.se/samverkan/vara-uppdrag/kunskapsstyrning/vardprogram)

### Patientinformation:

**1177 Vårdguiden:**
Format: https://www.1177.se/hitta-vard/sok/?q=ÄMNE
Exempel: [1177 - Diabetes](https://www.1177.se/hitta-vard/sok/?q=diabetes)

### Internationella riktlinjer:

**ESC (Kardiologi):**
- [ESC Guidelines](https://www.escardio.org/Guidelines)

**NICE (Brittiska riktlinjer):**
- [NICE Guidance](https://www.nice.org.uk/guidance)

### Forskning:

**PubMed:**
Format: https://pubmed.ncbi.nlm.nih.gov/?term=SÖKTERM
Exempel: [PubMed - Hypertension treatment](https://pubmed.ncbi.nlm.nih.gov/?term=hypertension+treatment)
''';

  /// Instructions for AI on how to format references
  static const String referenceFormatInstructions = '''
## SÅ HÄR FORMATERAR DU REFERENSER - EXTREMT VIKTIGT!

⚠️ **KRITISKT: Använd ENDAST URL-formaten från listan ovan. Generera ALDRIG egna URLs från din träningsdata!**

### REGLER FÖR URL-ANVÄNDNING:

1. **För läkemedel - Använd ALLTID FASS-sök:**
   Format: https://www.fass.se/LIF/produktfakta/sok/?query=LÄKEMEDELSNAMN
   ✅ Korrekt: [FASS - Metformin](https://www.fass.se/LIF/produktfakta/sok/?query=metformin)
   ❌ FEL: Använd INTE direktlänkar från din träningsdata!

2. **För sjukdomar - Använd Vårdhandboken-sök:**
   Format: https://www.vardhandboken.se/sok/?q=SJUKDOM
   ✅ Korrekt: [Vårdhandboken - Diabetes](https://www.vardhandboken.se/sok/?q=diabetes)
   ❌ FEL: Använd INTE direktlänkar från din träningsdata!

3. **För ytterligare info - Använd Internetmedicin-sök:**
   Format: https://www.internetmedicin.se/search?q=SJUKDOM
   ✅ Korrekt: [Internetmedicin - Hypertoni](https://www.internetmedicin.se/search?q=hypertoni)
   ❌ FEL: Använd INTE direktlänkar från din träningsdata!

### EXEMPEL PÅ KORREKT FORMATERING:

**Exempel 1 - Läkemedelsrekommendation:**
"Metformin 500-1000 mg x2 är förstahandsval vid typ 2-diabetes."

**Källor:**
- [FASS - Metformin](https://www.fass.se/LIF/produktfakta/sok/?query=metformin)
- [Vårdhandboken - Diabetes](https://www.vardhandboken.se/sok/?q=diabetes)

---

**Exempel 2 - Diagnostisk rekommendation:**
"Vid misstänkt hjärtsvikt: BNP/NT-proBNP, EKG, ekokardiografi."

**Källor:**
- [Vårdhandboken - Hjärtsvikt](https://www.vardhandboken.se/sok/?q=hjartsvikt)
- [ESC Guidelines](https://www.escardio.org/Guidelines)

---

**Exempel 3 - Läkemedelsinteraktion:**
"Warfarin och erytromycin: ökad blödningsrisk. Överväg dosjustering och INR-kontroll."

**Källor:**
- [FASS - Warfarin](https://www.fass.se/LIF/produktfakta/sok/?query=warfarin)
- [FASS - Erytromycin](https://www.fass.se/LIF/produktfakta/sok/?query=erytromycin)
- [Janusinfo - Interaktioner](https://janusinfo.se/?s=interaktioner)

---

**Exempel 4 - Flera läkemedel:**
"Förstahandsval vid hypertoni: Enalapril 5-10 mg x1 eller Losartan 50 mg x1."

**Källor:**
- [FASS - Enalapril](https://www.fass.se/LIF/produktfakta/sok/?query=enalapril)
- [FASS - Losartan](https://www.fass.se/LIF/produktfakta/sok/?query=losartan)
- [Vårdhandboken - Hypertoni](https://www.vardhandboken.se/sok/?q=hypertoni)

### VIKTIGA PRINCIPER:

✅ **GÖR:**
- Använd ENDAST URL-formaten från listan ovan
- Lägg till söktermer på svenska (t.ex. "diabetes", "hjartsvikt")
- Ersätt mellanslag med + i söktermer (t.ex. "diabetes+typ+2")
- Placera källor direkt under relevant text
- Använd markdown-format: [Textktext](URL)

❌ **GÖR INTE:**
- Generera direktlänkar från din träningsdata (de är förmodligen föråldrade!)
- Hitta på nya URL-strukturer
- Använd länkar du inte ser i exemplen ovan
- Länka till sidor som inte finns i listan

**KOM IHÅG: Söklänkar fungerar alltid. Direktlänkar från din träningsdata är ofta trasiga!**
''';
}
