# SGM Caloi — Resumo do Projeto (estado atual)

**Empresa:** Caloi Norte SA · Distrito Industrial de Manaus
**O que é:** Portal de Gestão de Manutenção (SGM) em Flask que consome os dados do programa **TPM** e os apresenta em uma capa visual + dashboards.

---

## 🚀 PRODUÇÃO — NO AR (Railway)
- **SGM (portal/dashboards):** https://web-production-e43ec.up.railway.app  → login `admin` / `admin123`
- **TPM (registro de OS + API):** https://web-production-97918.up.railway.app
- **Integração:** o SGM lê os dados do TPM via API `GET /api/dados/os|plano|colaboradores?key=...`
  - Local (PC): lê o Excel direto da pasta irmã do TPM.
  - Nuvem (Railway): usa a API do TPM (`TPM_API_URL`, `SGM_API_KEY`).
- **Repositórios GitHub:** `rcampos2000/SGM-Caloi` e `rcampos2000/caloi-tpm`
- **Portas locais:** TPM 5000 · SGM 5001.

### Pendências de segurança/acabamento
- Trocar a senha do `admin` em produção.
- Definir `SECRET_KEY` próprio no SGM (hoje usa o padrão do código).
- (Opcional) `SGM_API_KEY` forte nos dois serviços (hoje no padrão `caloi-sgm-2026`).
- **Revogar** o token do GitHub antigo que ficou exposto.

---

## 📁 Pastas (na Área de Trabalho)
- **SGM_Caloi** → este projeto (portal/dashboards). Caminho:
  `C:\Users\campo\OneDrive\Área de Trabalho\SGM_Caloi`
- **Manutencao_TPM** → programa TPM (Flask separado) + banco de dados em Excel:
  `C:\Users\campo\OneDrive\Área de Trabalho\Manutencao_TPM`
  - `Manutencao_TPM.xlsx` → registros de OS (paradas)
  - `Plano_de_Acao.xlsx` → ações e peças necessárias

> O SGM **lê** esses Excel; quem **grava** é o TPM. O `app.py` detecta a pasta `Manutencao_TPM` automaticamente quando é "irmã" do SGM (dev local); em produção usa a variável `TPM_DATA_DIR`.

## 🌐 Integração com o TPM
- URL do TPM (online): **https://manutencao-tpm.up.railway.app**
- Configurável via env `TPM_URL` no `app.py`.
- O ícone "OS de Manutenção" na capa abre o TPM em nova aba (registro de OS).
- Os dashboards são de **leitura** e atualizam a cada abertura/refresh.

---

## ✅ O que já está pronto

### Capa (página de rosto) — `rosto.html`
Servida em `/portal`. Visual:
- Roda de bicicleta 3D (pneu com volume, aro, raios cruzados, coroa de marchas no centro que gira)
- 13 peças mecânicas (porca, engrenagem, elo, flange) orbitando por fora da roda, giro lento, hover aumenta + gira a peça
- Fundo: imagem `fotos/Paisagem.webp` (ciclista no pôr do sol) com leve escurecimento
- Cores Caloi (vermelho + azul), marca d'água "caloi", título industrial (fonte Anton)
- Cards ligados:
  - **OS de Manutenção** → abre o TPM (nova aba)
  - **KPIs / Indicadores** e **cubo central** → `/modulo/ordens`
  - **Plano de Ação** → `/modulo/plano-acao`
  - **Peças de Reposição** → `/modulo/pecas`
  - **Head Count** → `/modulo/headcount`
  - Demais módulos → aviso "em breve"

### Dashboards (estilo claro/executivo, Chart.js) — `templates/modulos/`
1. **ordens.html** (`/modulo/ordens`) — OS/KPIs. Lê `Manutencao_TPM.xlsx`.
   KPIs: total, concluídas, pendentes, horas paradas, MTTR, disponibilidade, equipamentos, técnicos.
   Gráficos: paradas/mês, status, top equipamentos, motivos, horas/mês, horas por setor. Filtros + tabela.
2. **plano_acao.html** (`/modulo/plano-acao`) — Plano de Ação. Lê `Plano_de_Acao.xlsx`.
   KPIs: total, pendentes, concluídas, com peças, equipamentos, técnicos. Gráficos + tabela.
3. **headcount.html** (`/modulo/headcount`) — Head Count = **horas trabalhadas por técnico**, vindas das OS do TPM (`Total Horas Paradas` × `Técnico Responsável`).
4. **pecas.html** (`/modulo/pecas`) — Peças de Reposição, do campo `Peças Necessárias` do Plano de Ação.

Todos têm botão **"← Voltar à Capa"** (→ `/portal`).

### Telas de acesso
- `templates/login.html` — login (admin / admin123)
- `app.py` — rotas: `/` → `/portal`, `/login`, `/logout`, `/portal` (serve `rosto.html`), `/fotos/<arquivo>`, `/modulo/<...>`, `/api/upload/<modulo>`

### Esquema real das colunas
- **OS (`Manutencao_TPM.xlsx`):** ID, Data/Hora Registro, Data Ocorrência, Equipamento, Código do Equipamento, Técnico Responsável, Setor Produtivo, Horário de Parada, Horário de Liberação, Total Horas Paradas, Motivo da Parada, Solução do Problema, Observações, Assinatura Técnico, Nome Solicitante, Liberação Solicitante, Status (Concluído/Pendente).
- **Plano (`Plano_de_Acao.xlsx`):** ID Registro, Data/Hora, Equipamento, Código, Setor, Técnico, Outros Problemas Encontrados, Peças Necessárias, Status.

---

## ▶️ Como rodar
1. Dois cliques em **`INICIAR_SGM.bat`** (instala dependências, abre o navegador e sobe o servidor)
   - ou: `cd` na pasta → `pip install -r requirements.txt` → `python app.py`
2. Navegador: **http://localhost:5000** → login **admin / admin123**
3. Ao mudar o `app.py`, **reiniciar o servidor** (Ctrl+C e rodar de novo) + **Ctrl+F5** no navegador.

## 💾 Backup
- Snapshot zip em `backups/SGM_snapshot_AAAAMMDD_HHMMSS.zip`
- Git não funciona bem nesta pasta (OneDrive); para versionar com GitHub, melhor mover o projeto para fora do OneDrive (ex.: `C:\Projetos\SGM_Caloi`).

## ⚠️ Segurança (pendência)
- Foram apagados arquivos com token exposto no SGM (`github_token.txt`, `UPLOAD_GITHUB.py`, `CONTEXTO_PROJETO.md`).
- A pasta **Manutencao_TPM** ainda tem `github_token.txt` e `UPLOAD_GITHUB.py` com token. **Revogar o token no GitHub** (Settings → Developer settings → Personal access tokens) e apagar esses arquivos.

---

## 🔜 Próximos passos sugeridos
- Dashboards restantes: **Custos, Projetos, Melhoria Contínua, Segurança, Documentos, Planejamento/PM** (estes hoje dependem de upload de Excel próprio via `/api/upload/<modulo>`, pois não vêm do TPM).
- Deploy no Railway: definir `TPM_DATA_DIR` (volume compartilhado `/data`), `TPM_URL` e `SECRET_KEY` nos dois serviços.
- Opcional: criar telas/dados próprios para os módulos que não existem no TPM.
