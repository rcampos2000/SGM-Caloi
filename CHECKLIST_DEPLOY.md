# ✅ Checklist de Deploy — SGM + TPM

> As chaves (`SGM_API_KEY`, `SECRET_KEY`) foram geradas pelo Claude no chat.
> Guarde-as num gerenciador de senhas. **Não** salve as chaves neste arquivo (ele pode ir ao GitHub).

---

## 0) Preparação (uma vez)
- [ ] Instalar Git: https://git-scm.com/download/win
- [ ] **Revogar o token antigo** no GitHub (Settings → Developer settings → Personal access tokens → Delete)
- [ ] Mover os dois projetos para fora do OneDrive (rodar `MOVER_PARA_PROJETOS.bat` em cada):
  - `C:\Projetos\Manutencao_TPM`
  - `C:\Projetos\SGM_Caloi`  (lado a lado → o SGM acha os dados do TPM localmente)

## 1) TPM → GitHub → Railway
- [ ] Em `C:\Projetos\Manutencao_TPM`, rodar `SUBIR_GITHUB.bat` (repo: `rcampos2000/caloi-tpm`)
- [ ] Railway (projeto do TPM) → Variables:
  - [ ] `SECRET_KEY` = (chave do TPM)
  - [ ] `SGM_API_KEY` = (a MESMA que será usada no SGM)
  - [ ] `DATA_DIR` = `/data`  + Volume montado em `/data`
- [ ] Confirmar redeploy e abrir `https://web-production-97918.up.railway.app`
- [ ] Testar a API:
      `https://web-production-97918.up.railway.app/api/dados/os?key=SUA_SGM_API_KEY` → deve retornar JSON
- [ ] Conferir aba **Configurações → Técnicos** (cadastro de colaboradores com capacitação até 10)

## 2) SGM → GitHub → Railway
- [ ] Em `C:\Projetos\SGM_Caloi`, rodar `SUBIR_GITHUB.bat` (repo: `sgm-caloi` — criar em github.com/new)
- [ ] Railway (novo projeto do SGM) → Deploy from repo `sgm-caloi`
- [ ] Variables do SGM:
  - [ ] `SECRET_KEY` = (chave do SGM)
  - [ ] `TPM_URL` = `https://web-production-97918.up.railway.app`
  - [ ] `TPM_API_URL` = `https://web-production-97918.up.railway.app`
  - [ ] `SGM_API_KEY` = (a MESMA do TPM)
- [ ] Settings → Networking → **Generate Domain**
- [ ] Abrir o domínio do SGM → login `admin` → ver a capa e os dashboards com dados

## 3) Verificações finais
- [ ] KPIs/OS/Plano/Peças/Histórico mostram dados (vêm do TPM via API)
- [ ] Head Count mostra horas + função/férias/capacitação (Colaboradores.xlsx)
- [ ] Ícone "OS de Manutenção" na capa abre o TPM
- [ ] Trocar a senha padrão `admin` em produção

---

## Como rodar LOCAL (sem nuvem)
- TPM: `INICIAR` na pasta do TPM → `http://localhost:5000`
- SGM: `INICIAR_SGM.bat` → `http://localhost:5001`
- (lado a lado em `C:\Projetos\` → o SGM lê o Excel do TPM direto do disco)

## Atualizações futuras
- Mudou o código? rode `SUBIR_GITHUB.bat` do projeto → o Railway faz redeploy sozinho.
- Mudou só dados (OS, colaboradores)? nada a fazer — o portal lê na hora.
