# Power for telecommunications

telco equipment is very typically powered by -48V DC
electronics requires a DC rather than an AC source
48V is low enough to be safe (ELV)
Lower voltages are not preferred as P == VI and more current >> larger cabling and more losses 
+ve earth reduces galvanic corrosion

## For Mains Powered sites

Main exchange - typically 4 - 8 hours b/u
Mobile Base station: typically 1 - 4 hours b/u

Telstra - more conservative approach - 0 outages - $$$
eg Vodafone - more cost concious approach - $

Typical daily operation, batteries are not required to be operated (always on regardless).

## For wind / solar powered sites
similar architecture, but there's no AC, so swap out the rectifier for a converter, which converts DC-DC. It will have a wide range input with the same output characteristics as above.

As the power from wind or sun is necessarily less reliable, it's required to have a longer autonomy. Could be anywhere from 12 hours to 5 days.
Factors to consider
availability of wind / sun
- seasonal factors
- short term unpredictability (clouds, no wind)

Depending on importance / proximity of other sites, may require a genset to guard against prolonged outage

Batteries will be cycled daily


### Rectifiers (converters):
Typical stats:
    Efficiency: ~97%
    - Requires least amount of input ($)
    - Outputs the least amount of heat * 
    Power Factor: ~0.99
    - least amount of useless "power" 

## Batteries
- Overwhelmingly Lead Acid
    - finite life 
    - 5 - 20 years. Depends a lot on number of cycles 
    - Sealed (no free electrolyte)
- NiCd
    - used a bit in industrial applications
    - last longer / harder clean up 
- Lithium
    - too expensive (weight usually not a consideration)
- New Generation Flow batteries
    - for renewable Zinc Bromide (wet)
    - less prone to degredation per cycle


## System
AC - DC: Rectifiers OR DC - DC: Converters
Common Bus feeding
    - Batteries
    - Distribution Panel to load

Sizing: 
    - First size the battery for load / autonomy
    - Then size the charger to supply the load + recharge 
        - need MUCH more recharge power for renewable sites.
            - maybe 10% of battery capacity for city mains powered
            - maybe 200% of battery capacity for remote solar site
    - Then add modules(s) for redundancy
        (electronics relatively cheap cf cost of outage)

There can be _very_ high currents flowing in such a system (P = VI ... Low Voltage => High Current) so very important to protect all cabling with circuit breakers. Even a moderately sized 12V battery has enough power to vapourize an uninsulated spanner. But important to limit operation of fuse or CB to just the most immediate failure, so as to not knock out the whole system.



Size:
- in Aus, overwhelmingly we use 19" racks, usually 45RU (2200mm) 600mm x 600mm footprint.
- 1 x ~ 3kw module would be 4RU high (177.8mm) with 4 per 19"
- max I have seen is 40 modules in a rack ~ 120kw / 2400A with external distribution (4 racks from memory) and batteries (~ 4000kg ?). (Optus Belrose)
- mobiles, more typically half a rack with space for telco equipment above / below

Redundancy 
    - at every stage. Cost dependent

Maintenance
    - many sites can never be switched off, so maintenance windows tend to be small hours, not always great for supervising engineer.

