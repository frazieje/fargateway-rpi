ans=""

if [ "$1" == "-y" ]; then
    ans="y"
fi

while [ "$ans" != "y" ] && [ "$ans" != "yes" ] && [ "$ans" != "n" ] && [ "$ans" != "no" ]; do

    echo -e "Generate Profile? WARNING this will delete any existing profiles. Continue? (y/n): \c "
    read ans

    ans="$(echo -e "${ans}" | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]')"

done

if [ "$ans" == "y" ] || [ "$ans" == "yes" ]; then

cd conf

rm profile.conf

rm -rf profile_tmp/

mkdir profile_tmp
cd profile_tmp

openssl genrsa -out key.pem 2048

openssl pkcs8 -topk8 -inform PEM -outform PEM -in key.pem -out key8.pem -nocrypt

openssl req -new -key key.pem -out req.pem -outform PEM -subj /CN=jble6lowpanshoveld/O=client/ -nodes

cd ../../ca/mqca

openssl ca -config mqopenssl.cnf -in ../../conf/profile_tmp/req.pem -out ../../conf/profile_tmp/cert.pem -days 3650 -notext -batch -extensions client_ca_extensions

cp cacert.pem ../../conf/profile_tmp/cacert.pem

rm ../../conf/profile_tmp/req.pem

cd ../../conf

touch profile.conf

echo "-----BEGIN PROFILE IDENTIFIER-----" >> profile.conf

RANGE=16

profile_chars="0123456789abcdef"

profile_id=""

for (( i=0; i<8; i++ )); do
  number=$RANDOM
  let "number %= $RANGE"
  profile_id="${profile_id}`expr substr ${profile_chars} ${number} 1`"
done

echo "$profile_id" >> profile.conf

echo "-----END PROFILE IDENTIFIER-----" >> profile.conf

echo "-----BEGIN NODE-----" >> profile.conf

echo "-----BEGIN CLIENT CERT AND KEY-----" >> profile.conf

cat profile_tmp/cert.pem >> profile.conf

cat profile_tmp/key8.pem >> profile.conf

echo "-----END CLIENT CERT AND KEY-----" >> profile.conf

echo "-----BEGIN CA CERT-----" >> profile.conf

cat profile_tmp/cacert.pem >> profile.conf

echo "-----END CA CERT-----" >> profile.conf

echo "-----END NODE-----" >> profile.conf

rm -rf profile_tmp/

fi
