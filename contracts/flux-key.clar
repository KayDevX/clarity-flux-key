;; FluxKey Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-unauthorized (err u100))
(define-constant err-key-exists (err u101))
(define-constant err-no-key (err u102))

;; Data structures
(define-map keys 
  { key-id: uint } 
  { 
    encrypted-value: (string-utf8 1024),
    version: uint,
    owner: principal,
    created-at: uint
  }
)

(define-map access-rights
  { key-id: uint, principal: principal }
  { can-access: bool }
)

(define-map access-logs
  { key-id: uint, timestamp: uint }
  { 
    principal: principal,
    action: (string-utf8 24)
  }
)

;; Data vars
(define-data-var key-counter uint u0)

;; Private functions
(define-private (is-authorized (key-id uint) (caller principal))
  (let (
    (access-entry (map-get? access-rights { key-id: key-id, principal: caller }))
  )
  (is-some access-entry)
  )
)

;; Public functions
(define-public (create-key (encrypted-value (string-utf8 1024)))
  (let (
    (key-id (+ (var-get key-counter) u1))
  )
    (map-set keys
      { key-id: key-id }
      {
        encrypted-value: encrypted-value,
        version: u1,
        owner: tx-sender,
        created-at: block-height
      }
    )
    (var-set key-counter key-id)
    (ok key-id)
  )
)

(define-public (grant-access (key-id uint) (to principal))
  (let (
    (key (map-get? keys { key-id: key-id }))
  )
    (asserts! (is-eq tx-sender (get owner key)) err-unauthorized)
    (map-set access-rights
      { key-id: key-id, principal: to }
      { can-access: true }
    )
    (ok true)
  )
)

(define-public (revoke-access (key-id uint) (from principal))
  (let (
    (key (map-get? keys { key-id: key-id }))
  )
    (asserts! (is-eq tx-sender (get owner key)) err-unauthorized)
    (map-delete access-rights { key-id: key-id, principal: from })
    (ok true)
  )
)

(define-public (rotate-key (key-id uint) (new-encrypted-value (string-utf8 1024)))
  (let (
    (key (map-get? keys { key-id: key-id }))
  )
    (asserts! (is-eq tx-sender (get owner key)) err-unauthorized)
    (map-set keys
      { key-id: key-id }
      {
        encrypted-value: new-encrypted-value,
        version: (+ (get version key) u1),
        owner: tx-sender,
        created-at: block-height
      }
    )
    (ok true)
  )
)

(define-read-only (get-key (key-id uint))
  (let (
    (key (map-get? keys { key-id: key-id }))
  )
    (asserts! (is-authorized key-id tx-sender) err-unauthorized)
    (ok key)
  )
)
