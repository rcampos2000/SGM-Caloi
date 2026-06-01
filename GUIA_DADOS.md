# SGM Caloi — Guia de Dados (caminhos e estruturas)

Este guia explica **de onde vêm os dados**, **onde estão salvos** e a **estrutura** de cada fonte.
Resumo visual: ver `ARQUITETURA.html` (abrir no navegador).

---

## 1. Onde estão os arquivos

### Projeto SGM (portal/dashboards)
`C:\Users\campo\OneDrive\Área de Trabalho\SGM_Caloi`
- `app.py` — backend Flask (rotas e leitura dos dados)
- `rosto.html` — capa (servida em `/portal`)
- `templates/modulos/*.html` — dashboards
- `templates/login.html` — login
- `fotos/` — imagens (fundo, logos) servidas em `/fotos/...`
- `uploads/` — Excel de módulos sem fonte automática (criado quando há upload)
- `sgm/usuarios.json` — usuários (criado no 1º boot)
- `backups/` — snapshots `.zip`

### Programa TPM (banco de dados das OS) — sistema separado
`C:\Users\campo\OneDrive\Área de Trabalho\Manutencao_TPM`
- **`Manutencao_TPM.xlsx`** — registros de OS (paradas) ← fonte principal
- **`Plano_de_Acao.xlsx`** — ações e peças necessárias
- **`Colaboradores.xlsx`** — efetivo da manutenção (função, setor, admissão, férias, capacitação) → usado pelo Head Count
- App online do TPM: **https://manutencao-tpm.up.railway.app**

> O SGM **lê** esses Excel; quem **grava** é o programa TPM (onde se registra a OS).

---

## 2. Como o SGM encontra os dados do TPM

No `app.py`, função `_detect_tpm_dir()`:
1. **Produção (Railway):** usa a variável de ambiente `TPM_DATA_DIR` (volume compartilhado, ex.: `/data`).
2. **Local (PC):** usa a pasta irmã `Manutencao_TPM` (ao lado de `SGM_Caloi`).
3. **Fallback:** a própria pasta do SGM.

Variáveis de ambiente relevantes:
- `TPM_DATA_DIR` — pasta dos Excel do TPM (produção)
- `TPM_URL` — endereço do programa TPM (botões "Abrir TPM" / ícone OS) — padrão: `https://manutencao-tpm.up.railway.app`
- `SECRET_KEY` — chave de sessão do Flask
- `DATA_DIR` — pasta de dados próprios do SGM (usuários, uploads)

---

## 3. Estrutura das planilhas

### 3.1 `Manutencao_TPM.xlsx` — aba "Registros" (OS / paradas)
| Coluna | Uso no SGM |
|---|---|
| ID | identificador |
| Data/Hora Registro | data do registro |
| **Data Ocorrência** | data usada nos gráficos por mês |
| **Equipamento** | nome do equipamento (Histórico, rankings) |
| **Código do Equipamento** | TAG/código |
| **Técnico Responsável** | Head Count (horas por técnico) |
| **Setor Produtivo** | filtros e gráficos por setor |
| Horário de Parada / Liberação | janela da parada |
| **Total Horas Paradas** | base de MTTR, horas, disponibilidade |
| **Motivo da Parada** | gráficos de motivos |
| Solução do Problema | tabela/histórico |
| Observações | — |
| Assinatura Técnico / Nome Solicitante / Liberação Solicitante | — |
| **Status** | Concluído / Pendente |

Usada por: **OS**, **Head Count**, **Histórico por TAG**.

### 3.2 `Plano_de_Acao.xlsx` — aba "Plano de Ação"
| Coluna | Uso no SGM |
|---|---|
| ID Registro | identificador |
| Data/Hora | data |
| **Equipamento** | agrupamentos |
| **Código** | TAG |
| **Setor** | filtros |
| **Técnico** | — |
| Outros Problemas Encontrados | descrição da ação |
| **Peças Necessárias** | módulo Peças (definida × "a definir") |
| **Status** | Pendente / Concluído |

Usada por: **Plano de Ação**, **Peças**.

### 3.3 `Colaboradores.xlsx` — aba "Colaboradores" (efetivo)
Colunas: Nome · Função · Setor · Admissão · Férias Início 1 · Férias Fim 1 · Férias Início 2 · Férias Fim 2 · Capacitação 1 · Validade 1 · Capacitação 2 · Validade 2 · Capacitação 3 · Validade 3.
- **Função:** Mecânico, Eletricista, Ferramenteiro, Serralheiro, Auxiliar de Manutenção.
- **Nome** deve bater com "Técnico Responsável" das OS → horas trabalhadas automáticas.
- Datas em dd/mm/aaaa. Editável diretamente no Excel (na pasta do TPM).

Usada por: **Head Count** (função, férias, capacitação). As horas e atividades vêm das OS.

> A detecção de colunas no front-end é **flexível** (procura por nome aproximado), então pequenas variações de cabeçalho continuam funcionando.

---

## 4. Mapa módulo → fonte

| Módulo (rota) | Fonte | Status |
|---|---|---|
| OS / KPIs (`/modulo/ordens`) | Manutencao_TPM.xlsx | ✅ ativo |
| Plano de Ação (`/modulo/plano-acao`) | Plano_de_Acao.xlsx | ✅ ativo |
| Head Count (`/modulo/headcount`) | Colaboradores.xlsx (efetivo) + Manutencao_TPM.xlsx (horas/atividades) | ✅ ativo |
| Peças (`/modulo/pecas`) | Plano_de_Acao.xlsx (Peças Necessárias) | ✅ ativo |
| Histórico por TAG (`/modulo/historico`) | Manutencao_TPM.xlsx | ✅ ativo |
| Custos (`/modulo/custos`) | **Diretório de rede da empresa** | 🟡 futuro |
| Documentos (`/modulo/documentos`) | **Diretório de rede da empresa** | 🟡 futuro |
| Projetos / Melhoria / Segurança / Planejamento | Upload de Excel (`uploads/<modulo>.xlsx`) ou a definir | 🟡 futuro |

---

## 5. Pendências de dados (futuro)
- **Custos** e **Documentos**: serão lidos de um **diretório de rede** da empresa.
  - A definir: caminho UNC (ex.: `\\servidor\manutencao\custos\...`), formato dos arquivos e permissão de acesso do servidor onde o SGM rodar.
- Definir a estrutura (colunas) desses dados quando o acesso à rede estiver disponível.

---

## 6. Atualização dos dados
- A cada **abertura/refresh** de um dashboard, o `app.py` **relê** o arquivo na hora → mostra o dado mais recente.
- Não é streaming contínuo: para ver algo novo, basta atualizar a página.
- Em produção (Railway), TPM e SGM devem **compartilhar o mesmo volume** (`TPM_DATA_DIR`) para o SGM enxergar o que o TPM gravou.
