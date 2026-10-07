# Memeriksa dan meminta hak Administrator (UAC) jika belum aktif
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Warning "Membutuhkan hak Administrator. Meminta akses UAC..."
    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

$hostsPath = "$env:windir\System32\drivers\etc\hosts"

function Show-Menu {
    Clear-Host
    Write-Host "==================================" -ForegroundColor Cyan
    Write-Host "      WINDOWS HOSTS MANAGER       " -ForegroundColor Cyan
    Write-Host "=================================="
    Write-Host "1. Show list existing host"
    Write-Host "2. Add new host"
    Write-Host "0. Exit"
    Write-Host "=================================="
}

while ($true) {
    Show-Menu
    $choice = Read-Host "Pilih opsi {1,2,0}"

    switch ($choice) {
        '1' {
            Write-Host "`n[Existing Hosts List]" -ForegroundColor Yellow
            # Menampilkan isi file hosts (mengabaikan baris kosong atau komentar default Windows agar lebih bersih)
            Get-Content $hostsPath | Where-Object { $_ -match '\S' } | Write-Host
            Write-Host "----------------------------------"
            pause
        }
        '2' {
            Write-Host "`n[Add New Host]" -ForegroundColor Yellow
            $ip = Read-Host "Input IP Address"
            $hostname = Read-Host "Input hostname"
            $comment = Read-Host "Comment (optional)"

            # Validasi input tidak boleh kosong untuk IP dan Hostname
            if ([string]::IsNullOrWhiteSpace($ip) -or [string]::IsNullOrWhiteSpace($hostname)) {
                Write-Host "ERROR: IP Address dan Hostname tidak boleh kosong!" -ForegroundColor Red
                pause
                continue
            }

            # Format baris baru (IP [tab] Hostname [tab] # Comment)
            $newLine = "$ip`t$hostname"
            if (-not [string]::IsNullOrWhiteSpace($comment)) {
                $newLine += "`t# $comment"
            }

            try {
                # Cek dan matikan mode Read-Only jika aktif
                $file = Get-Item $hostsPath
                $wasReadOnly = $file.IsReadOnly
                if ($wasReadOnly) {
                    $file.IsReadOnly = $false
                }

                # Append ke file hosts
                Add-Content -Path $hostsPath -Value $newLine -Force
                Write-Host "SUCCESS: Host berhasil ditambahkan -> $newLine" -ForegroundColor Green

                # Kembalikan mode Read-Only jika sebelumnya aktif
                if ($wasReadOnly) {
                    $file.IsReadOnly = $true
                }
            } catch {
                Write-Host "FAILED: Gagal menyimpan ke file hosts. Pastikan file tidak sedang dibuka dan Antivirus Anda tidak memblokir PowerShell." -ForegroundColor Red
            }
            pause
        }
        '0' {
            Write-Host "Keluar dari program..." -ForegroundColor Cyan
            Start-Sleep -Seconds 1
            exit
        }
        default {
            Write-Host "Pilihan tidak valid. Silakan pilih 1, 2, atau 0." -ForegroundColor Red
            pause
        }
    }
}
