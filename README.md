# Recipes

The test app displays a list of recipes fetched from an api call. It has ability to filter recipe by preparation time and difficulty, tapping on a recipe it will present extra details about it.

- The architecure is written in MVVM with no reactive bindings.
- Persisting the network data was implemented using NSURLCache. 
- The UI was done using xib file.
- Dependecy injection is handled through Dependecy Container implementation. 
