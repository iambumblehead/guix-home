;; guix and nonguix channels are pinned to compatible commit/tag versions
;;
;; %default-channels also defines a channel named "guix", but using master branch,
;; Only "our" guix channel is used, as it appears first in the list.

(define flatwhatson
  (channel
   (name 'flat)
   (url "https://github.com/flatwhatson/guix-channel.git")
   (introduction
    (make-channel-introduction
     "33f86a4b48205c0dc19d7c036c85393f0766f806"
     (openpgp-fingerprint
      "736A C00E 1254 378B A982  7AF6 9DBE 8265 81B6 4490")))))

(define guixrus
  (channel
   (name 'guixrus)
   (url "https://git.sr.ht/~whereiseveryone/guixrus")
   (introduction
    (make-channel-introduction
     "7c67c3a9f299517bfc4ce8235628657898dd26b2"
     (openpgp-fingerprint
      "CD2D 5EAA A98C CB37 DA91  D6B0 5F58 1664 7F8B E551")))))

(append (list
         (channel
          (name 'guix)
          (url "https://git.savannah.gnu.org/git/guix.git")
          ;; (commit "v1.4.0")
          (introduction
           (make-channel-introduction
            "9edb3f66fd807b096b48283debdcddccfea34bad"
            (openpgp-fingerprint
             "BBB0 2DDF 2CEA F6A8 0D1D  E643 A2A0 6DF2 A33A 54FA"))))
         (channel
          (name 'nonguix)
          (url "https://gitlab.com/nonguix/nonguix")
          ;; (commit "v1.4.0")
          (introduction
           (make-channel-introduction
            "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
            (openpgp-fingerprint
             "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5")))))
        %default-channels)
