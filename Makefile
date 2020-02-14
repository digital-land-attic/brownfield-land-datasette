INDEX=../brownfield-land-collection/index
DATA=../brownfield-land-collection/dataset
CACHE =../organisation-collection/collection

DATAFILES=\
	$(CACHE)/organisation.csv\
	$(INDEX)/resource.csv\
	$(INDEX)/link.csv\
	$(INDEX)/link-organisation.csv\
	$(INDEX)/entries.csv\
	$(INDEX)/issue.csv\
	$(INDEX)/log.csv

DB=brownfield-land.db

serve: $(DB)
	datasette --load-extension=/usr/lib/x86_64-linux-gnu/mod_spatialite.so $(DB)

$(DB): $(DATAFILES) Makefile points.py
	rm -f $@
	sqlite-utils insert $(DB) --pk organisation organisation $(CACHE)/organisation.csv --csv
	sqlite-utils insert $(DB) --pk resource resource $(INDEX)/resource.csv --csv
	sqlite-utils insert $(DB) --pk link link $(INDEX)/link.csv --csv
	sqlite-utils insert $(DB) log $(INDEX)/log.csv --csv
	sqlite-utils add-foreign-key $(DB) log resource resource resource
	sqlite-utils add-foreign-key $(DB) log link link link
	sqlite-utils insert $(DB) site $(INDEX)/dataset.csv --csv
	sqlite-utils add-foreign-key $(DB) site organisation organisation organisation 
	sqlite-utils add-foreign-key $(DB) site resource resource resource
	sqlite-utils insert $(DB) link-organisation $(INDEX)/link-organisation.csv --csv
	sqlite-utils add-foreign-key $(DB) link-organisation link link link
	sqlite-utils add-foreign-key $(DB) link-organisation organisation organisation organisation
	sqlite-utils insert $(DB) issue $(INDEX)/issue.csv --csv
	sqlite-utils add-foreign-key $(DB) issue resource resource resource
	python3 points.py

clean:
	rm -f $(DB)

init::
	pip3 install --upgrade -r requirements.txt

