# SGM Caloi — Guia de Deploy (GitHub → Railway)

Fluxo para publicar o portal SGM. O TPM é um projeto separado (já tem seu próprio repositório/Railway).

---

## Parte 0 — Tirar o projeto do OneDrive (IMPORTANTE, faça primeiro)

O git **não funciona bem** dentro do OneDrive, e há um repositório git acidental na sua
pasta de usuário (`C:\Users\campo`) — por isso a 1ª tentativa tentou commitar a pasta
inteira (Dropbox, NTUSER.DAT, etc.) e falhou.

**Faça uma vez:**
1. Dê dois cliques em **`MOVER_PARA_PROJETOS.bat`** → copia o projeto para `C:\Projetos\SGM_Caloi`.
2. Daqui em diante, trabalhe e rode os `.bat` **a partir de `C:\Projetos\SGM_Caloi`**.

> (Opcional, recomendado) Se aquele `.git` em `C:\Users\campo` foi criado por engano,
> vale remover a pasta `C:\Users\campo\.git` para o git parar de "enxergar" a pasta de usuário.
> Só remova se tiver certeza de que não usa git ali de propósito.

---

## Parte 1 — Enviar o código para o GitHub
(rode a partir de `C:\Projetos\SGM_Caloi`)

### Opção A — pelo script (mais fácil)
1. Crie um repositório vazio no GitHub: https://github.com/new
   - Nome sugerido: **sgm-caloi** · Visibilidade: Private · **NÃO** marque "Add README".
2. Dê dois cliques em **`SUBIR_GITHUB.bat`** (na pasta do SGM).
3. Na 1ª vez ele pede a **URL do repositório** (ex.: `https://github.com/SEU_USUARIO/sgm-caloi.git`). Cole e Enter.
4. Pode abrir o navegador pedindo login do GitHub — autorize. Pronto.
5. Nas próximas vezes, basta rodar o `.bat` de novo para enviar as atualizações.

### Opção B — comandos manuais (PowerShell na pasta do SGM)
```
git init
git branch -M main
git remote add origin https://github.com/SEU_USUARIO/sgm-caloi.git
git add -A
git commit -m "Primeiro envio do SGM"
git push -u origin main
```

> Observação: este OneDrive às vezes atrapalha o git. Se der erro estranho, o ideal é manter o projeto fora do OneDrive (ex.: `C:\Projetos\SGM_Caloi`).

---

## Parte 2 — Publicar no Railway

1. Acesse https://railway.app e faça login (pode usar a conta do GitHub).
2. **New Project → Deploy from GitHub repo → sgm-caloi**.
3. O Railway detecta Python e usa o **Procfile** (`web: gunicorn app:app`). Em ~2 min sobe.
4. Em **Variables**, configure:
   - `SECRET_KEY` = (uma string longa aleatória)
   - `TPM_URL` = `https://web-production-97918.up.railway.app`
   - `TPM_DATA_DIR` = caminho dos Excel do TPM no servidor (ver Parte 3)
   - `PORT` = (o Railway já injeta; não precisa definir)
5. Em **Settings → Networking → Generate Domain** para ter a URL pública do SGM.

---

## Parte 3 — IMPORTANTE: os dados em produção

O SGM **lê** os dados do TPM (`Manutencao_TPM.xlsx`, `Plano_de_Acao.xlsx`, `Colaboradores.xlsx`).
Agora ele funciona de **duas formas automaticamente**:

1. **Local (no PC):** se encontra o Excel na pasta do TPM, lê direto do disco.
2. **Online (Railway):** se não há Excel local, **busca via HTTP** na API do TPM
   (`GET /api/dados/os|plano|colaboradores?key=...`).

### Como ligar o modo online (SGM no Railway lendo do TPM)
No serviço do **SGM** no Railway, defina as variáveis:
- `TPM_API_URL` = `https://web-production-97918.up.railway.app`
- `SGM_API_KEY` = uma chave secreta (ex.: `caloi-sgm-2026` ou outra mais forte)

No serviço do **TPM** no Railway, defina a MESMA chave:
- `SGM_API_KEY` = (idêntica à do SGM)

Pronto: o SGM passa a puxar os dados do TPM online, sem precisar de volume compartilhado.
> A API do TPM (`/api/dados/...`) só responde com a chave correta; sem ela retorna 401.

---

## Resumo rápido
1. `SUBIR_GITHUB.bat` → manda o código pro GitHub.
2. Railway → New Project → from repo → variáveis (`SECRET_KEY`, `TPM_URL`, `TPM_DATA_DIR`) → Generate Domain.
3. Definir como o SGM acessa os dados do TPM em produção (recomendado: rodar SGM no PC, ou adaptar para ler via HTTP).
