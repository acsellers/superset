set -e

usage() {
   echo "usage: syntropy-release.sh <SUPERSET_VERSION>"
}

if [ -z "$1" ]; then
  if [ -z "${SUPERSET_VERSION}" ]; then
    echo "No parameters found and no required environment variables set"
    echo "usage: syntropy-release.sh <SUPERSET_VERSION>"
    usage;
    exit 1
  fi
else
  export SUPERSET_VERSION="${1}"
fi

export SUPERSET_VER=apache-superset-"${SUPERSET_VERSION}"
export SUPERSET_TARBALL="${SUPERSET_VER}".tar.gz
export SUPERSET_BASE_PATH=build/"${SUPERSET_VERSION}"
export SUPERSET_TARBALL_PATH="${SUPERSET_BASE_PATH}"/"${SUPERSET_TARBALL}"
cd superset-frontend
npm run build
cd ../build
tar -xf "${SUPERSET_TARBALL}"
rm "${SUPERSET_VER}"/superset/static/assets/*.js
cp ../superset/static/assets/*.js "${SUPERSET_VER}"/superset/static/assets/

rm "${SUPERSET_VER}"/superset/static/assets/*.json
cp ../superset/static/assets/*.json "${SUPERSET_VER}"/superset/static/assets/

rm "${SUPERSET_VER}"/superset/static/assets/*.css
cp ../superset/static/assets/*.css "${SUPERSET_VER}"/superset/static/assets/

rm "${SUPERSET_VER}"/superset/static/assets/*.png
cp ../superset/static/assets/*.png "${SUPERSET_VER}"/superset/static/assets/

rm "${SUPERSET_VER}"/superset/static/assets/*.jpg
cp ../superset/static/assets/*.jpg "${SUPERSET_VER}"/superset/static/assets/

{ grep -v "superset/static/assets/" ${SUPERSET_VER}/apache_superset.egg-info/SOURCES.txt & ls ${SUPERSET_VER}/superset/static/assets/*.* | sed  -e 's/^/superset\/static\/assets\//'; } | sort > SOURCES.txt
mv SOURCES.txt "${SUPERSET_VER}"/apache_superset.egg-info/SOURCES.txt
mv $SUPERSET_TARBALL "${SUPERSET_VER}"-original.tar.gz
tar -cvzf $SUPERSET_TARBALL "${SUPERSET_VER}/"
