#!/bin/sh
### BEGIN INIT INFO
# Provides:          rgpio_pins.sh
# Required-Start:
# Required-Stop:
# Default-Start:     S
# Default-Stop:
# Short-Description: Creates links for rgpio in/dev/gpio
# Description:       rgpio is used to conect expternal Relay box with ModBus/RTU control
# Fixes Devices with no native Digital Interfaces, not just RPi's! Victron's CCGX and Multi/Easy Solar GX Products.
# Once I'm done I'll clean up, but IT WORKS at least for 1 - 8 Relay Module.
### END INIT INFO


logger "S90rgpio_pins.sh has just started."

# Removed in v3.3.2 Code, now handled by dbus call.
#nbunit=$(cat /data/RemoteGPIO/conf/units.conf)

# Native Relays and DI's based on Platform
#have rpiNativeRelay set to 2, it should be 0.  Need to figure out the /data/RemoteGPIO/sys/class/gpio/gpio101 & 2 for RPi
rpiNativeRelay=2
rpiNativeDigin=0
gxNativeRelay=2
cerboNativeDigin=4
ekranoNativeDigin=2


logger "nbunit = $nbunit"

# Removed in v3.3.2 Code
# Kill existing rgpio_service in case the script is called after HW configuration change:
# kill $(ps | grep '{rgpio_service}' | grep -v grep | awk '{print $1}') 2>/dev/null
# kill $(ps | grep '{rgpio_service}' | grep -v grep | awk '{print $1}') 2>/dev/null && logger "just killed rgpio_service"

get_setting()
        {

        dbus-send --print-reply=literal --system --type=method_call --dest=com.victronenergy.settings $1 com.victronenergy.BusItem.GetValue | awk '/int32/ { print $3 }'

        }

set_setting()
        {

        dbus-send --print-reply=literal --system --type=method_call --dest=com.victronenergy.settings $1 com.victronenergy.BusItem.SetValue $2

        }

#packageManger paths. Added CB 4/14/2024
#This will go when I move to reading the /etc/venus/machine file.  It contains the running device type

get_platform_setting()
        {
                dbus-send --print-reply=literal --system --type=method_call --dest=com.victronenergy.packageManager $1 com.victronenergy.BusItem.GetValue | awk ' { print $3 }'
        }

#Added in v3.3.2 Code
nbunit=$(get_setting /Settings/RemoteGPIO/NumberUnits)
logger "nbunit = $nbunit" 

nbrelayunit1=$(get_setting /Settings/RemoteGPIO/Unit1/NumRelays)
logger "nbrelayunit1 = $nbrelayunit1"
nbrelayunit2=$(get_setting /Settings/RemoteGPIO/Unit2/NumRelays)
logger "nbrelayunit2 = $nbrelayunit2"
nbrelayunit3=$(get_setting /Settings/RemoteGPIO/Unit3/NumRelays)
logger "nbrelayunit3 = $nbrelayunit3"

#Added in v3.3.2 Code
service=$(get_setting /Settings/Services/RemoteGPIO)
logger "service = $service"

# com.victronenergy.packageManager/Platform = 
# "Raspberry Pi 4" if running on a Pi 4 Model B
# awk $3 Returns "Pi" for RPi 2,3 & 4

#machine            Platform                    Relay's         Digital Inputs
#ccgx               CCGX                        0                   0
#einstein           Cerbo GX                    4                   4
#cerbosgx           Cerbo SGX                   4                   4
#bealglebone        Venus GX                    1                   5                   Deprecated
#canvu500           CanVu 500                   1                   1
#nanopi             Multi/Easy Solar GX         0                   0
#raspberrypi2       Raspberry Pi 2/3            0                   0
#raspberrypi4       Raspberry Pi 4              0                   0
#ekrano             Ekrano GX                   2                   2


 
nbplatform=$(get_platform_setting /Platform)
logger "nbplatform = $nbplatform"
if [ $nbplatform = "" ]
    then
    logger "Platform dbus call, returned Null -  Something is very wrong"
fi



## Find total number of relays for all modules

# If nbunit is a 0, exit.  This will deal with the first reload after install.
#if [ $nbunit -eq 0 ]
#    then
#       exit 0
#fi

if [ $nbunit -eq 1 ]
    then
    nbrelays=$nbrelayunit1
    logger nbunit is 1. "nbrelays = $nbrelays" 
fi

if [ $nbunit -eq 2 ]
    then
    nbrelays=$(($nbrelayunit1 + $nbrelayunit2))
    logger "nbunit is 2. nbrelays = $nbrelays"
fi

if [ $nbunit -eq 3 ]
    then
    nbrelays=$(($nbrelayunit1 + $nbrelayunit2 + $nbrelayunit3))
    logger "nbunit is 3. nbrelays = $nbrelays"
fi

#Added in Lucifers v3.2.2 code.
if [ $service -eq 0 ]
    then
    nbrelays=0
    logger "nbunit is 0. nbrelays = $nbrelays"
fi

#Deal with cleaning up a RPi
logger "Starting cleanup Case"
case $nbplatform in
        Pi)
                logger "It's a RPi Cleanup Relays (3-i) DI (1-k)"
				# Maybe we can deal with this later on.  Works just fine as it is.
 #              rm -f /dev/gpio/relay_1   ---  Device not defined in /data/RemoteGPIO/sys/class/gpio/gpio101 for RPi
 #              rm -f /dev/gpio/relay_2   ---  Device not defined in /data/RemoteGPIO/sys/class/gpio/gpio102 for RPi
                rm -f /dev/gpio/relay_3
                rm -f /dev/gpio/relay_4
                rm -f /dev/gpio/relay_5
                rm -f /dev/gpio/relay_6
                rm -f /dev/gpio/relay_7
                rm -f /dev/gpio/relay_8
                rm -f /dev/gpio/relay_9
                rm -f /dev/gpio/relay_a
                rm -f /dev/gpio/relay_b
                rm -f /dev/gpio/relay_c
                rm -f /dev/gpio/relay_d
                rm -f /dev/gpio/relay_e
                rm -f /dev/gpio/relay_f
                rm -f /dev/gpio/relay_g
                rm -f /dev/gpio/relay_h
                rm -f /dev/gpio/relay_i
                rm -f /dev/gpio/digital_input_1
                rm -f /dev/gpio/digital_input_2
                rm -f /dev/gpio/digital_input_3
                rm -f /dev/gpio/digital_input_4
                rm -f /dev/gpio/digital_input_5
                rm -f /dev/gpio/digital_input_6
                rm -f /dev/gpio/digital_input_7
                rm -f /dev/gpio/digital_input_8
                rm -f /dev/gpio/digital_input_9
                rm -f /dev/gpio/digital_input_a
                rm -f /dev/gpio/digital_input_b
                rm -f /dev/gpio/digital_input_c
                rm -f /dev/gpio/digital_input_d
                rm -f /dev/gpio/digital_input_e
                rm -f /dev/gpio/digital_input_f
                rm -f /dev/gpio/digital_input_g
                rm -f /dev/gpio/digital_input_h
                rm -f /dev/gpio/digital_input_i
                rm -f /dev/gpio/digital_input_j
                rm -f /dev/gpio/digital_input_k
                ;;
        #Case: Not a RPi, move along.
        *)
                # Clean existing gpio in case HW configuration has changed
                logger "Not a RPi Cleanup relay(3-i) DI (5-k)"
                rm -f /dev/gpio/relay_3
                rm -f /dev/gpio/relay_4
                rm -f /dev/gpio/relay_5
                rm -f /dev/gpio/relay_6
                rm -f /dev/gpio/relay_7
                rm -f /dev/gpio/relay_8
                rm -f /dev/gpio/relay_9
                rm -f /dev/gpio/relay_a
                rm -f /dev/gpio/relay_b
                rm -f /dev/gpio/relay_c
                rm -f /dev/gpio/relay_d
                rm -f /dev/gpio/relay_e
                rm -f /dev/gpio/relay_f
                rm -f /dev/gpio/relay_g
                rm -f /dev/gpio/relay_h
                rm -f /dev/gpio/relay_i
                rm -f /dev/gpio/digital_input_5
                rm -f /dev/gpio/digital_input_6
                rm -f /dev/gpio/digital_input_7
                rm -f /dev/gpio/digital_input_8
                rm -f /dev/gpio/digital_input_9
                rm -f /dev/gpio/digital_input_a
                rm -f /dev/gpio/digital_input_b
                rm -f /dev/gpio/digital_input_c
                rm -f /dev/gpio/digital_input_d
                rm -f /dev/gpio/digital_input_e
                rm -f /dev/gpio/digital_input_f
                rm -f /dev/gpio/digital_input_g
                rm -f /dev/gpio/digital_input_h
                rm -f /dev/gpio/digital_input_i
                rm -f /dev/gpio/digital_input_j
                rm -f /dev/gpio/digital_input_k
                ;;
esac

## insert links for number of relays and DI
if [[ $nbunit -eq 1 || $nbunit -eq 2 || $nbunit = 3 ]]; then
    if [[ $nbrelays -eq 2 || $nbrelays -eq 4 || $nbrelays -eq 6 || $nbrelays -eq 8 || $nbrelays -eq 10 || $nbrelays -eq 12 || $nbrelays -eq 14 || $nbrelays -eq 16 ]]; then
        case $nbplatform in
            Pi)
                #Relays
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio103 /dev/gpio/relay_3
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio104 /dev/gpio/relay_4

                #Digital_Inputs
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio205 /dev/gpio/digital_input_1
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio206 /dev/gpio/digital_input_2                    
                ;;
            #Case: Not a RPi, move along.
            *)
                #Relays
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio103 /dev/gpio/relay_3
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio104 /dev/gpio/relay_4

                #Digital_Inputs
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio205 /dev/gpio/digital_input_5
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio206 /dev/gpio/digital_input_6
                ;;
        esac                    
     fi


     if [[ $nbrelays -eq 4 || $nbrelays -eq 6 || $nbrelays -eq 8 || $nbrelays -eq 10 || $nbrelays -eq 12 || $nbrelays -eq 14 || $nbrelays -eq 16 ]]; then
        case $nbplatform in
            Pi)
                #Relays
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio105 /dev/gpio/relay_5
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio106 /dev/gpio/relay_6

                #Digital_Inputs
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio207 /dev/gpio/digital_input_3
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio208 /dev/gpio/digital_input_4
                ;;

            #Case: Not a RPi, move along.    
            *)
                #Relays
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio105 /dev/gpio/relay_5
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio106 /dev/gpio/relay_6

                #Digital_Inputs
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio207 /dev/gpio/digital_input_7
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio208 /dev/gpio/digital_input_8
                ;;
        esac
     fi


     if [[ $nbrelays -eq 6 || $nbrelays -eq 8 || $nbrelays -eq 10 || $nbrelays -eq 12 || $nbrelays -eq 14 || $nbrelays -eq 16 ]]; then
        case $nbplatform in
            Pi)
                #Relays
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio107 /dev/gpio/relay_7
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio108 /dev/gpio/relay_8
            
                #Digital_Inputs
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio209 /dev/gpio/digital_input_5
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio210 /dev/gpio/digital_input_6
                ;;

            #Case: Not a RPi, move along.
            *)
                #Relays
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio107 /dev/gpio/relay_7
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio108 /dev/gpio/relay_8

                #Digital_Inputs
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio209 /dev/gpio/digital_input_9
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio210 /dev/gpio/digital_input_a
                ;;
        esac
     fi


     if [[ $nbrelays -eq 8 || $nbrelays -eq 10 || $nbrelays -eq 12 || $nbrelays -eq 14 || $nbrelays -eq 16 ]]; then
        case $nbplatform in
            Pi)
                #Relays
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio109 /dev/gpio/relay_9
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio110 /dev/gpio/relay_a

                #Digital_Inputs
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio211 /dev/gpio/digital_input_7
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio212 /dev/gpio/digital_input_8
                ;;

            #Case: Not a RPi, move along.
            *)
                #Relays
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio109 /dev/gpio/relay_9
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio110 /dev/gpio/relay_a

                #Digital_Inputs
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio211 /dev/gpio/digital_input_b
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio212 /dev/gpio/digital_input_c
                ;;
        esac
     fi


     if [[ $nbrelays -eq 10 || $nbrelays -eq 12 || $nbrelays -eq 14 || $nbrelays -eq 16 ]]; then
        case $nbplatform in
            Pi)
                #Relays
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio111 /dev/gpio/relay_b
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio112 /dev/gpio/relay_c
            
                #Digital_Inputs
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio213 /dev/gpio/digital_input_9
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio214 /dev/gpio/digital_input_a
                ;;

            #Case: Not a RPi, move along.
            *)
                #Relays
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio111 /dev/gpio/relay_b
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio112 /dev/gpio/relay_c

                #Digital_Inputs
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio213 /dev/gpio/digital_input_d
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio214 /dev/gpio/digital_input_e
                ;;
        esac
    fi


    if [[ $nbrelays -eq 12 || $nbrelays -eq 14 || $nbrelays -eq 16  ]]; then
        case $nbplatform in
            Pi)
                #Relays
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio113 /dev/gpio/relay_d
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio114 /dev/gpio/relay_e

                #Digital_Inputs
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio215 /dev/gpio/digital_input_b
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio216 /dev/gpio/digital_input_c
                ;;
            
            #Case: Not a RPi, move along.
            *)
                #Relays
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio113 /dev/gpio/relay_d
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio114 /dev/gpio/relay_e

                #Digital_Inputs
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio217 /dev/gpio/digital_input_f
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio218 /dev/gpio/digital_input_g
                ;;
        esac
    fi


    if [[ $nbrelays -eq 14 || $nbrelays -eq 16 ]]; then
        case $nbplatform in
            Pi)
                #Relays
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio115 /dev/gpio/relay_f
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio116 /dev/gpio/relay_g

                #Digital_Inputs
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio217 /dev/gpio/digital_input_d
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio218 /dev/gpio/digital_input_e
                ;;
            
            #Case: Not a RPi, move along.
            *)
                #Relays
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio115 /dev/gpio/relay_f
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio116 /dev/gpio/relay_g

                #Digital_Inputs
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio217 /dev/gpio/digital_input_h
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio218 /dev/gpio/digital_input_i
                ;;
        esac
    fi


    if [[ $nbrelays -eq 16 ]]; then
        case $nbplatform in
            Pi)
                #Relays
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio117 /dev/gpio/relay_h
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio118 /dev/gpio/relay_i

                #Digital_Inputs
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio219 /dev/gpio/digital_input_f
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio220 /dev/gpio/digital_input_g
                ;;
            
            #Case: Not a RPi, move along.
            *)
                #Relays
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio117 /dev/gpio/relay_h
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio118 /dev/gpio/relay_i

                #Digital_Inputs
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio219 /dev/gpio/digital_input_j
                ln -sf /data/RemoteGPIO/sys/class/gpio/gpio220 /dev/gpio/digital_input_k
                ;;
        esac
    fi



    ##Create conf files

    ## Creation of conf files will differ based on platform, RPi's have no built-in Relays or DI's.
    ## 
    
    #Handle Module 1
    logger "Starting Module 1 -  Create Conf Files Case"

    case $nbplatform in
        Pi)
            #Creating RPi Relay_unit1.conf file
            logger "Starting Pi Module 1 - Create Conf File Cases"
            logger "Start setting variables for RPi - Module 1 - unit1.conf file"
            #Leaving Relay's along for now, just concentrate on DI's, they work as is.
            #Down the road maybe we can set rpiNativeRelay = 0, it's set to 2 now.  Not messing with it.
            firstrelay=$(($rpiNativeRelay + 1))
            logger "RPi firstrelay = $firstrelay"
            lastrelay=$(($nbrelayunit1 + $rpiNativeRelay))
            logger "Pi lastrelay = $lastrelay"
            firstdigin=$(($rpiNativeDigin + 1))
            logger "RPi firstdigin = $rpiNativeDigin"
            lastdigin=$nbrelayunit1
            logger "GX lastdigin = $lastdigin"
            ;;
        # Case: For now it's a Cerbo GX.
        *)
            logger "Start setting variables for Cerbo - Module 1 - unit1.conf file"
            firstrelay=$(($gxNativeRelay++))
            logger "GX firstrelay = $firstrelay"
            lastrelay=$(($nbrelayunit1 + $gxNativeRelay))
            logger "GX lastrelay = $lastrelay"
            firstdigin=$(($cerboNativeDigin++))
            logger "GX firstdigin = $firstdigin"
            lastdigin=$(($nbrelayunit1 + $cerboNativeDigin))
            logger "GX lastdigin = $lastdigin"
            ;;
        esac
        logger "Exited Module 1 -  Create Conf Files Case"

    echo "" > /data/RemoteGPIO/FileSets/Conf/Relays_unit1.conf
    logger "Just cleared Relays_unit1.conf"
    logger "Starting for relay in loop"
    for relay in $( seq $firstrelay $lastrelay )
    do
        nb=$relay
        logger "relay in do loop nb = $nb"
        if [[ $nb -eq 10 ]]; then
            nb=a
        fi
        logger "Adding Relay $nb to Relay_unit1.conf file."
        echo "/dev/gpio/relay_$nb/value" >> /data/RemoteGPIO/FileSets/Conf/Relays_unit1.conf
    done
    logger "End Relays_unit1.conf file"

    echo "" > /data/RemoteGPIO/FileSets/Conf/Digital_Inputs_unit1.conf
    logger "Just cleared Digital_Inputs_unit1.conf"
    logger "Starting for digin in loop"
    for digin in $( seq $firstdigin $lastdigin)
    do
        nb=$digin
        if [[ $nb -eq 10 ]]; then
            nb=a
        elif [[ $nb -eq 11 ]]; then
            nb=b
        elif [[ $nb -eq 12 ]]; then
            nb=c
        fi
        logger "Adding Digitial Input $nb to Digital_Inputs_unit1.conf file."
        echo "/dev/gpio/digital_input_$nb/value" >> /data/RemoteGPIO/FileSets/Conf/Digital_Inputs_unit1.conf
    done
    logger "Finished Module 1 -  Create Conf Files Case"
fi


#Handle Module 2
logger "Starting Handling Module 2"
if [[ $nbunit -eq 2 || $nbunit -eq 3 ]]; then
    a=2
    b=4
    c=3
    d=5
    e=1
    case $nbplatform in
        Pi)
            #Creating RPi Relay_unit2.conf file
            logger "Start setting variables for RPi - Module 2 - unit2.conf files"
            firstrelay=$(($nbrelayunit1 + $rpiNativeRelay+1))
            firstrelay=$(($nbrelayunit1 + $c))
            firstdigin=$(($nbrelayunit1 + $d))
            lastrelay=$(($nbrelayunit1 + $nbrelayunit2 + $a))
            #No offset.  RPi's have no native DI's
            lastdigin=$(($nbrelayunit1 + $nbrelayunit2))
            ;;
        *)
            logger "Start setting variables for Cerbo - Module 2 - unit2.conf files"
            firstrelay=$(($nbrelayunit1 + $c))
            firstdigin=$(($nbrelayunit1 + $d))
            lastrelay=$(($nbrelayunit1 + $nbrelayunit2 + $a))
            lastdigin=$(($nbrelayunit1 + $nbrelayunit2 + $b))
            ;;
    esac

    echo "" > /data/RemoteGPIO/FileSets/Conf/Relays_unit2.conf
    for relay in $( seq $firstrelay $lastrelay )
    do
        nb=$relay
        if [[ $nb -eq 10 ]]; then
            nb=a
        elif [[ $nb -eq 11 ]]; then
            nb=b
        elif [[ $nb -eq 12 ]]; then
            nb=c
        elif [[ $nb -eq 13 ]]; then
            nb=d
        elif [[ $nb -eq 14 ]]; then
            nb=e
        elif [[ $nb -eq 15 ]]; then
            nb=f
        elif [[ $nb -eq 16 ]]; then
            nb=g
        elif [[ $nb -eq 17 ]]; then
            nb=h
        elif [[ $nb -eq 18 ]]; then
            nb=i
        fi
        echo "/dev/gpio/relay_$nb/value" >> /data/RemoteGPIO/FileSets/Conf/Relays_unit2.conf
    done

    echo "" > /data/RemoteGPIO/FileSets/Conf/Digital_Inputs_unit2.conf
    for digin in $( seq $firstdigin $lastdigin)
    do
        nb=$digin
        if [[ $nb -eq 10 ]]; then
            nb=a
        elif [[ $nb -eq 11 ]]; then
            nb=b
        elif [[ $nb -eq 12 ]]; then
            nb=c
        elif [[ $nb -eq 13 ]]; then
            nb=d
        elif [[ $nb -eq 14 ]]; then
            nb=e
        elif [[ $nb -eq 15 ]]; then
            nb=f
        elif [[ $nb -eq 16 ]]; then
            nb=g
        elif [[ $nb -eq 17 ]]; then
            nb=h
        elif [[ $nb -eq 18 ]]; then
            nb=i
        elif [[ $nb -eq 19 ]]; then
            nb=j
        elif [[ $nb -eq 20 ]]; then
            nb=k
        fi
        echo "/dev/gpio/digital_input_$nb/value" >> /data/RemoteGPIO/FileSets/Conf/Digital_Inputs_unit2.conf
    done
fi

#Have not coded this part yet for platform detection.
#Handle Module 3
if [[ $nbunit -eq 3 ]]
    then
    a=2
    b=4
    c=3
    d=5
    firstrelay=$(($nbrelayunit1 + $nbrelayunit2 + $c))
    firstdigin=$(($nbrelayunit1 + $nbrelayunit2 + $d))
    lastrelay=$(($nbrelayunit1 + $nbrelayunit2 + $nbrelayunit3 + $a))
    lastdigin=$(($nbrelayunit1 + $nbrelayunit2 + $nbrelayunit3 + $b))
    echo "" > /data/RemoteGPIO/FileSets/Conf/Relays_unit3.conf
    for relay in $( seq $firstrelay $lastrelay )
    do
        nb=$relay
        if [[ $nb -eq 10 ]]; then
            nb=a
        elif [[ $nb -eq 11 ]]; then
            nb=b
        elif [[ $nb -eq 12 ]]; then
            nb=c
        elif [[ $nb -eq 13 ]]; then
            nb=d
        elif [[ $nb -eq 14 ]]; then
            nb=e
        elif [[ $nb -eq 15 ]]; then
            nb=f
        elif [[ $nb -eq 16 ]]; then
            nb=g
        elif [[ $nb -eq 17 ]]; then
            nb=h
        elif [[ $nb -eq 18 ]]; then
            nb=i
        fi
        echo "/dev/gpio/relay_$nb/value" >> /data/RemoteGPIO/FileSets/Conf/Relays_unit3.conf
    done

    echo "" > /data/RemoteGPIO/FileSets/Conf/Digital_Inputs_unit3.conf
    for digin in $( seq $firstdigin $lastdigin)
    do
        nb=$digin
        if [[ $nb -eq 10 ]]; then
            nb=a
        elif [[ $nb -eq 11 ]]; then
            nb=b
        elif [[ $nb -eq 12 ]]; then
            nb=c
        elif [[ $nb -eq 13 ]]; then
            nb=d
        elif [[ $nb -eq 14 ]]; then
            nb=e
        elif [[ $nb -eq 15 ]]; then
            nb=f
        elif [[ $nb -eq 16 ]]; then
            nb=g
        elif [[ $nb -eq 17 ]]; then
            nb=h
        elif [[ $nb -eq 18 ]]; then
            nb=i
        elif [[ $nb -eq 19 ]]; then
            nb=j
        elif [[ $nb -eq 20 ]]; then
            nb=k
        fi
        echo "/dev/gpio/digital_input_$nb/value" >> /data/RemoteGPIO/FileSets/Conf/Digital_Inputs_unit3.conf
    done
fi        

logger "End of main script"

#Service
# This script, runs after start-digitalinputs.sh.
# start-digitalinputs.sh is there for one reason, to check if it's running on device with no DI's.
# This includes all the RPi varients and serveral Victron products.
# If it doesn't find /dev/gpio/digital_input_1, it never kicks off dbus_digitalinputs.py
# No dbus_digitalinputs.py, no dbus_digitalinputs service, no digital inputs.
case $nbplatform in
    Pi)
        svc -t /service/dbus-systemcalc-py
        svc -u /service/dbus-digitalinputs
        ;;
    *)
        svc -t /service/dbus-systemcalc-py
        svc -t /service/dbus-digitalinputs
        ;;
esac

# Removed in v3.3.2
#[ ! -f /service/rgpio ] && ln -sf /data/RemoteGPIO/service/rgpio /service/rgpio

# Removed in v3.3.2
#For managing reboot of Dingtian IOT devices
#nohup /data/RemoteGPIO/rgpio_service >/dev/null 2>&1 &

# Added in v3.3.2
svc -t /service/rgpio_driver

exit 0
