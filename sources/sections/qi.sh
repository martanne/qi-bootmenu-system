setupfor qi-bootloader

[ -z "$MACHINE" ] && MACHINE="GTA02"

case "$MACHINE" in
  GTA01|gta01)
    CPU="s3c2410"
    ;;
  *)
    CPU="s3c2442"
    ;;
esac

make CPU="$CPU" CROSS_COMPILE="$CROSS" &&
cp image/qi-$CPU*.udfu $TOP || dienow 

cleanup qi-bootloader
