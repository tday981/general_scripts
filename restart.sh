echo -n "Restart processes? "
read answer

if [[ "$answer" == y || "$answer" == yes ]]; then

ssh root@bulldawg "pkill adh"
echo "Killed adh $?"
ssh root@bulldawg /rmds/adh2.1.1.E1/bin/adh &
echo "Started adh $?"

ssh root@bulldawg /rmds/ads2.1.1.E2/bin/stop_ads
echo "Stopped ads $?"
ssh root@bulldawg /rmds/ads2.1.1.E2/bin/start_ads &
echo "Started ads $?"

ssh root@bulldawg /rmds/dacs/bin/start_scp &
echo "Restarted scp $?"
fi
