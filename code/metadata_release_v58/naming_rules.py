"""Jinlong Ru; Cunli Pan. Publication names only; no scientific transformations."""
import re
ALIASES={
 'Data1_local.xlsx':'Supplementary_Data_1_Local_analyses.xlsx',
 'Data2_global.xlsx':'Supplementary_Data_2_Reference_genome_analyses.xlsx',
 'Data1_sheet_index.tsv':'Supplementary_Data_1_sheet_index.tsv',
 'Data1_field_dictionary.tsv':'Supplementary_Data_1_field_dictionary.tsv',
 'Data1_grouped_navigation.tsv':'Supplementary_Data_1_grouped_navigation.tsv',
 'Data1_S37_gaps.tsv':'Supplementary_Data_1_S37_gaps.tsv',
 'Data2_sheet_index.tsv':'Supplementary_Data_2_sheet_index.tsv',
 'Data2_field_dictionary.tsv':'Supplementary_Data_2_field_dictionary.tsv',
 'Data2_grouped_navigation.tsv':'Supplementary_Data_2_grouped_navigation.tsv',
 'Table1_full_definitions.tsv':'Supplementary_Table_S1_full_definitions.tsv',
 'FigureS2-links.tsv':'Supplementary_Figure_S2_links.tsv',
}
REF=re.compile(r'(Supplementary Data [12]) ([SG]\d{2}(?:_[A-Za-z0-9_]+)?(?:\s*(?:[–/-]|,|and)\s*[SG]?\d{2}(?:_[A-Za-z0-9_]+)?)*)')
def normalize(s):
    for old,new in ALIASES.items():s=s.replace(old,new)
    s=re.sub(r'(?<!Supplementary )\bData ([1-4])\b',r'Supplementary Data \1',s)
    def worksheet(m):
        x=m[2];plural=bool(re.search(r'[–/,]|\band\b',x))
        return m[1]+', '+('worksheets ' if plural else 'worksheet ')+x
    s=REF.sub(worksheet,s)
    s=re.sub(r'\bSupplementary (Fig\.|Figure) ([1-4])',r'Supplementary \1 S\2',s)
    s=re.sub(r'\bSupplementary Figures ([1-4])([–-])([1-4])',r'Supplementary Figures S\1\2S\3',s)
    s=re.sub(r'\bSupplementary Figures ([1-4])',r'Supplementary Figures S\1',s)
    return s

def metadata(s):
    s=normalize(s)
    # These references name the definition ledger, which is Supplementary Table S1.
    s=re.sub(r'(?<!Supplementary )\bTable 1\b','Supplementary Table S1',s)
    return s
