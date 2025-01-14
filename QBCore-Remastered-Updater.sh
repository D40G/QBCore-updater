#Kill FiveM screen
screen -S FiveM -X quit

#Setting our work dictory as same location as script
cd "$(dirname "$0")"

#Making temporary folder to clone to and later remove
mkdir [qb] && cd [qb] && curl -s https://api.github.com/orgs/Qbox-project/repos?per_page=200 | jq -r '.[].clone_url' | xargs -n 1 git clone

#Here we remove script we do not need
rm -Rf txAdminRecipe qb-commandbinding 

#Now Remove old [qb] folder based on my folder being the following /home/FiveM/resources/[qb]
rm -Rf /home/FiveM/resources/[qb] && mkdir -p /home/FiveM/resources/[qb] && mv qb-* npwd /home/FiveM/resources/[qb]

#Now move the remaining scripts to /home/FiveM/resources/[standalone]
rm -Rf /home/FiveM/resources/[standalone]/ && mkdir -p /home/FiveM/resources/[standalone]  && mv * /home/FiveM/resources/[standalone]

#Let Graab overextended content
rm -Rf  /home/FiveM/resources/[ox] && git clone https://github.com/overextended/ox_lib.git /home/FiveM/resources/[ox]/ && git clone https://github.com/overextended/ox_target.git /home/FiveM/resources/[ox]/ && cd



#Now let grab latest FiveM files
rm -Rf  /home/FiveM/resources/[cfx-default] && git clone https://github.com/citizenfx/cfx-server-data.git [cfx] && cd [cfx]/resources && mkdir -p /home/FiveM/resources/[cfx-default] && mv * /home/FiveM/resources/[cfx-default] && cd


#Now let grab latest artifact based on latest recommended
url=https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/
version=$(curl  -sS 'https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/' | grep OPTIONAL  | sort | tail -1 | sed -n 's/.*LATEST OPTIONAL.."*//p' | sed 's/.$//')
getnewversion=$(curl 'https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/' |
    sed -e 's/^<a href=["'"'"']//i' |
    awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' |  grep $version | awk '{ print $2 }' | sed -n 's/.*href="..\([^"]*\).*/\1/p')
echo $getnewversion
newversion="${url}${getnewversion}"
echo $newversion
wget "$newversion"
tar xf fx.tar.xz
rm fx.tar.xz

#Remove old artifact files assuming it in /home and extract new
rm -Rf /home/run.sh && rm -Rf /home/alpine && mv alpine /home && mv run.sh /home

#Remove cache /home/FiveM/cache
rm -Rf /home/FiveM/cache
cd
rm -Rf [qb]
rm -Rf [cfx]

#Run FiveM inside screen
cd /home && screen -dmS FiveM bash run.sh; exec bash
