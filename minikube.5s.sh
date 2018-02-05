#!/bin/bash
# <bitbar.title>Minikube GUI</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>Cole Brumley</bitbar.author>
# <bitbar.author.github>colebrumley</bitbar.author.github>
# <bitbar.desc>A BitBar controller for minikube<bitbar.desc>
# <bitbar.image>http://i.imgur.com/Vulc3pu.png</bitbar.image>
# <bitbar.dependencies>minikube, kubectl</bitbar.dependencies>
# <bitbar.abouturl>https://github.com/colebrumley/bitbar-minikube</bitbar.abouturl>

MINIKUBE_LOGO_COLOR='iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAEbmAABG5gFxkAtgAAAAB3RJTUUH4gIFBxw0GMoMFgAAArtJREFUOMtlk01oFEkYhp/q6enOONlM/sYMHY0oehIPtmAU8aB7cFEEDwqCK+JhFyM2Iooe/EEQwZuHFtGI8aCyIhK8reAf+Dcki31YEWWCEUXbydg6E8dJxjHV5SHTMuoDBVVUvfVVvbyfoAHb8fFcC9vxTWBDqFgmQBOCLHDdc61qdCZC50c02/E3AX3pNvH7cSf+XNMIth2qFeI6N2zH7weuAioSiIaqJ4FiuaLOjQx0vxsaCx4AKwAJXO/t6ty4qM/vjutsBzo819pjOz6i/vS9U5LB/09bL4fGggPACX5lEtjV29U5sHiXP1cIdniudUCrb269dMxsGhoLPjWKK5PweeL7BQng/NBY8OJft2kCWBX9OaOM8P7uXP7xV6V+ayx5Z1hyz5Pf1wIoTYXz1mffDAMXbMefqQGLZGrqzGi1JrY9f8s/hXFMTWAa0JIUNCem50LAGf8jf+feUvgiY0pXF4EuHciomMoJhSZRDBY+cevJV+aPpniVVwhg+Ingcc9HZKY2bZrCEFLMBBboQDqeNze03uw0xtcEtN9Io1U1Rnom0VM6ylA8Q9L6qI1whqS0NiB1uz2NYicQ04Buf//Ls+XeUrXtWgZlhBTXF6gsLaEMRWhKystLFNe9B6DjaoaJhRXfc619wCwNiOdnr6jGPxjvlR6il3Sacslp1yQIKRBKkMgl0SoxlB4SG9eLka/CdvwFwN6e/nTfs/4XkyquzOZsijARon0RKAHoClHTKK8sogeG7LicMScWlw8CA1GQlgN82JQ3RSju6qU4Lbfbf0jR+B8BMilBsaZ9sKsM4LlWVqtHOQv8mXHnjJijicPJ4ZZfYticbcV43XQ0c6rnKbDFc61sY5SjfrjiudZm2/GPAJ11raqPkudaR23HP+e51l+RRjS2cp3/gIf14P3MamAJUIta+htbXCnnwMKirwAAAABJRU5ErkJggg=='

LANG="en_US.UTF-8"
# You may need to update the PATH to include minikube and kubectl
#PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export LANG PATH

if [[ $(minikube status | head -n 1) =~ Running ]]; then
    echo "|image=$MINIKUBE_LOGO_COLOR"
else
    echo "|image=$MINIKUBE_LOGO_BW"
    exit 0
fi
echo ---

while read -r STATUS; do
    if [[ $STATUS =~ Running ]]; then
        echo "$STATUS | color=green"
    else
        echo "$STATUS | color=red"
    fi
done < <(minikube status)

echo ---
echo "IP: $(minikube ip) | color=black"
echo ":bar_chart: Dashboard | bash=minikube param1=dashboard"
echo ---

echo Addons
while read -r STATUS; do
    PRETTY_STATUS=${STATUS//"- "}
    if [[ $STATUS =~ enabled ]]; then
        echo "-- $PRETTY_STATUS | color=green bash=minikube param1=addons param2=disable param3=${PRETTY_STATUS//": enabled"} refresh=true"
    else
        echo "-- $PRETTY_STATUS | color=red bash=minikube param1=addons param2=enable param3=${PRETTY_STATUS//": disabled"} refresh=true"
    fi
done < <(minikube addons list | sort)

echo Config
while read -r CONF; do
    echo "-- ${CONF//"- "} | color=black"
done < <(minikube config view | sort)
