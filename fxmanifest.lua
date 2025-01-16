fx_version 'cerulean'
game 'gta5'

lua54 'yes'
use_experimental_fxv2_oal 'yes'

author 'Atoshi'
description 'Core'
version '1.0.0'
repository 'https://github.com/atoshit/at_core'

shared_scripts {
    'shared/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',

    -- mysql
    'server/*.lua',

    -- Class
    'server/class/*.lua'
}

client_scripts {
    'client/wrapper/*.lua',
    'client/function/**/*.lua',
    'client/cache.lua',
    'client/class/*.lua',
    'client/*.lua'
}


client_scripts {
    "client/ipl/lib/common.lua"
    , "client/ipl/lib/observers/interiorIdObserver.lua"
    , "client/ipl/lib/observers/officeSafeDoorHandler.lua"
    , "client/ipl/lib/observers/officeCullHandler.lua"
    , "client/ipl/client.lua"

    -- GTA V
    , "client/ipl/gtav/base.lua"   -- Base IPLs to fix holes
    , "client/ipl/gtav/ammunations.lua"
    , "client/ipl/gtav/bahama.lua"
    , "client/ipl/gtav/cargoship.lua"
    , "client/ipl/gtav/floyd.lua"
    , "client/ipl/gtav/franklin.lua"
    , "client/ipl/gtav/franklin_aunt.lua"
    , "client/ipl/gtav/graffitis.lua"
    , "client/ipl/gtav/pillbox_hospital.lua"
    , "client/ipl/gtav/lester_factory.lua"
    , "client/ipl/gtav/michael.lua"
    , "client/ipl/gtav/north_yankton.lua"
    , "client/ipl/gtav/red_carpet.lua"
    , "client/ipl/gtav/simeon.lua"
    , "client/ipl/gtav/stripclub.lua"
    , "client/ipl/gtav/trevors_trailer.lua"
    , "client/ipl/gtav/ufo.lua"
    , "client/ipl/gtav/zancudo_gates.lua"

    -- GTA Online
    , "client/ipl/gta_online/apartment_hi_1.lua"
    , "client/ipl/gta_online/apartment_hi_2.lua"
    , "client/ipl/gta_online/house_hi_1.lua"
    , "client/ipl/gta_online/house_hi_2.lua"
    , "client/ipl/gta_online/house_hi_3.lua"
    , "client/ipl/gta_online/house_hi_4.lua"
    , "client/ipl/gta_online/house_hi_5.lua"
    , "client/ipl/gta_online/house_hi_6.lua"
    , "client/ipl/gta_online/house_hi_7.lua"
    , "client/ipl/gta_online/house_hi_8.lua"
    , "client/ipl/gta_online/house_mid_1.lua"
    , "client/ipl/gta_online/house_low_1.lua"

    -- DLC High Life
    , "client/ipl/dlc_high_life/apartment1.lua"
    , "client/ipl/dlc_high_life/apartment2.lua"
    , "client/ipl/dlc_high_life/apartment3.lua"
    , "client/ipl/dlc_high_life/apartment4.lua"
    , "client/ipl/dlc_high_life/apartment5.lua"
    , "client/ipl/dlc_high_life/apartment6.lua"

    -- DLC Heists
    , "client/ipl/dlc_heists/carrier.lua"
    , "client/ipl/dlc_heists/yacht.lua"

    -- DLC Executives & Other Criminals
    , "client/ipl/dlc_executive/apartment1.lua"
    , "client/ipl/dlc_executive/apartment2.lua"
    , "client/ipl/dlc_executive/apartment3.lua"

    -- DLC Finance & Felony
    , "client/ipl/dlc_finance/office1.lua"
    , "client/ipl/dlc_finance/office2.lua"
    , "client/ipl/dlc_finance/office3.lua"
    , "client/ipl/dlc_finance/office4.lua"
    , "client/ipl/dlc_finance/organization.lua"

    -- DLC Bikers
    , "client/ipl/dlc_bikers/cocaine.lua"
    , "client/ipl/dlc_bikers/counterfeit_cash.lua"
    , "client/ipl/dlc_bikers/document_forgery.lua"
    , "client/ipl/dlc_bikers/meth.lua"
    , "client/ipl/dlc_bikers/weed.lua"
    , "client/ipl/dlc_bikers/clubhouse1.lua"
    , "client/ipl/dlc_bikers/clubhouse2.lua"
    , "client/ipl/dlc_bikers/gang.lua"

    -- DLC Import/Export
    , "client/ipl/dlc_import/garage1.lua"
    , "client/ipl/dlc_import/garage2.lua"
    , "client/ipl/dlc_import/garage3.lua"
    , "client/ipl/dlc_import/garage4.lua"
    , "client/ipl/dlc_import/vehicle_warehouse.lua"

    -- DLC Gunrunning
    , "client/ipl/dlc_gunrunning/bunkers.lua"
    , "client/ipl/dlc_gunrunning/yacht.lua"

    -- DLC Smuggler's Run
    , "client/ipl/dlc_smuggler/hangar.lua"

    -- DLC Doomsday Heist
    , "client/ipl/dlc_doomsday/facility.lua"

    -- DLC After Hours
    , "client/ipl/dlc_afterhours/nightclubs.lua"

    -- DLC Diamond Casino (Requires forced build 2060 or higher)
    , "client/ipl/dlc_casino/casino.lua"
    , "client/ipl/dlc_casino/penthouse.lua"

    -- DLC Cayo Perico Heist (Requires forced build 2189 or higher)
    , "client/ipl/dlc_cayoperico/base.lua"
    , "client/ipl/dlc_cayoperico/nightclub.lua"
    , "client/ipl/dlc_cayoperico/submarine.lua"

    -- DLC Tuners (Requires forced build 2372 or higher)
    , "client/ipl/dlc_tuner/garage.lua"
    , "client/ipl/dlc_tuner/meetup.lua"
    , "client/ipl/dlc_tuner/methlab.lua"

    -- DLC The Contract (Requires forced build 2545 or higher)
    , "client/ipl/dlc_security/studio.lua"
    , "client/ipl/dlc_security/billboards.lua"
    , "client/ipl/dlc_security/musicrooftop.lua"
    , "client/ipl/dlc_security/garage.lua"
    , "client/ipl/dlc_security/office1.lua"
    , "client/ipl/dlc_security/office2.lua"
    , "client/ipl/dlc_security/office3.lua"
    , "client/ipl/dlc_security/office4.lua"

    -- DLC The Criminal Enterprises (Requires forced build 2699 or higher)
    , "client/ipl/gta_mpsum2/simeonfix.lua"
    , "client/ipl/gta_mpsum2/vehicle_warehouse.lua"
    , "client/ipl/gta_mpsum2/warehouse.lua"

    -- DLC Los Santos Drug Wars (Requires forced build 2802 or higher)
    , "client/ipl/dlc_drugwars/base.lua"
    , "client/ipl/dlc_drugwars/freakshop.lua"
    , "client/ipl/dlc_drugwars/garage.lua"
    , "client/ipl/dlc_drugwars/lab.lua"
    , "client/ipl/dlc_drugwars/traincrash.lua"

    -- DLC San Andreas Mercenaries (Requires forced build 2944 or higher)
    , "client/ipl/dlc_mercenaries/club.lua"
    , "client/ipl/dlc_mercenaries/lab.lua"
    , "client/ipl/dlc_mercenaries/fixes.lua"

    -- DLC The Chop Shop (Requires forced build 3095 or higher)
    , "client/ipl/dlc_chopshop/base.lua"
    , "client/ipl/dlc_chopshop/cargoship.lua"
    , "client/ipl/dlc_chopshop/cartel_garage.lua"
    , "client/ipl/dlc_chopshop/lifeguard.lua"
    , "client/ipl/dlc_chopshop/salvage.lua"

    -- DLC Bottom Dollar Bounties (Requires forced build 3258 or higher)
    --, "client/ipl/dlc_summer/base.lua"
    --, "client/ipl/dlc_summer/carrier.lua"
    --, "client/ipl/dlc_summer/office.lua"

    -- DLC Agents of Sabotage (Requires forced build 3407 or higher)
    --, "client/ipl/dlc_agents/base.lua"
    --, "client/ipl/dlc_agents/factory.lua"
    --, "client/ipl/dlc_agents/office.lua"
    --, "client/ipl/dlc_agents/airstrip.lua"
}
