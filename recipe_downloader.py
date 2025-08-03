import gkeepapi

# Přihlaš se ke svému Google účtu
keep = gkeepapi.Keep()
success = keep.login('tvůj.email@gmail.com', 'tvé-aplikacni-heslo')

# Synchronizace poznámek
keep.sync()

# Filtruj podle štítku "recepty"
notes = keep.find(labels=[keep.findLabel('recepty')])

# Výpis obsahu všech poznámek s tímto štítkem
for note in notes:
    print(f"=== {note.title} ===")
    print(note.text)
    print()
