FROM rocker/verse:3.4.1

RUN mkdir house_prices

# Restore package state
COPY packrat house_prices/packrat

WORKDIR house_prices

RUN r -e 'packrat::restore()'

# Copy in remaining files
COPY . .

RUN r initialise.r 

